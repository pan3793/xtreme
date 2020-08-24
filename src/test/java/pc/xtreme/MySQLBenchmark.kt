package pc.xtreme

import com.zaxxer.hikari.HikariConfig
import com.zaxxer.hikari.HikariDataSource
import io.micrometer.core.instrument.Metrics
import io.micrometer.core.instrument.Timer
import kotlinx.coroutines.*
import org.junit.jupiter.api.Test
import org.testcontainers.containers.MySQLContainer
import org.testcontainers.junit.jupiter.Container
import org.testcontainers.junit.jupiter.Testcontainers
import pc.xtreme.util.CollectionUtil
import java.sql.Connection
import java.sql.ResultSet
import java.sql.Statement
import javax.sql.DataSource

@ExperimentalCoroutinesApi
@Testcontainers(disabledWithoutDocker = true)
class MySQLBenchmark : ThreadPoolBenchmark<String, Unit>() {

    @Test
    fun test() = runBlocking {
        run()
    }

    override val concurrency = 16
    override val qps: Int = 200

    private val dataSource by lazy {
        HikariDataSource(HikariConfig().apply {
            driverClassName = "com.mysql.cj.jdbc.Driver"
            jdbcUrl = mysqlContainer.jdbcUrl
            username = mysqlContainer.username
            password = mysqlContainer.password
            maximumPoolSize = concurrency
        })
    }

    override fun source(): Iterable<String> = CollectionUtil
            .repeat(1000, loadFiles("sql", "sql"))
            .map { (_, sqlTemplate) ->
                sqlTemplate
                        .replace("{pattern_1}", "target_value_1")
                        .replace("{pattern_2}", "target_value_2")
            }

    override fun consumeAsync(record: String): Deferred<Unit> =
            GlobalScope.async { executeSql(dataSource, record) }

    private fun executeSql(dataSource: DataSource, sql: String) {
        val meanSample = Timer.start()
        try {
            dataSource.connection.use { conn: Connection ->
                conn.createStatement().use { statement: Statement ->
                    statement.executeQuery(sql).use { resultSet: ResultSet ->
                        while (resultSet.next()) {
                            resultSet.getString(1)
                        }
                    }
                }
            }
        } catch (ex: Exception) {
            log.error(sql, ex)
        } finally {
            meanSample.stop(Metrics.timer("sql_execute_duration"))
        }
    }

    companion object {
        private const val TEST_CONTAINERS_MYSQL_IMAGE = "mysql:5.7"

        @Container
        val mysqlContainer: MySQLContainer<*> = MySQLContainer<Nothing>(TEST_CONTAINERS_MYSQL_IMAGE).apply {
            withDatabaseName("xtreme")
            withInitScript("mysql/init.sql")
        }
    }
}