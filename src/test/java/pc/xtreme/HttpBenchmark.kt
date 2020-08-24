package pc.xtreme

import io.ktor.client.request.*
import io.ktor.util.*
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.runBlocking
import org.junit.jupiter.api.BeforeAll
import org.junit.jupiter.api.Test
import org.mockserver.integration.ClientAndServer
import org.mockserver.model.Delay
import org.mockserver.model.HttpRequest.request
import org.mockserver.model.HttpResponse.response
import java.time.Duration
import kotlin.random.Random
import kotlin.time.ExperimentalTime

@ExperimentalTime
@KtorExperimentalAPI
@ExperimentalCoroutinesApi
class HttpBenchmark : CioHttpBenchmark<String, String>() {

    @Test
    fun test() = runBlocking {
        run()
    }

    override val concurrency = 4
    override val qps: Int = 10
    override val timeout: Duration = Duration.ofSeconds(10)

    override fun source(): Iterable<String> = (1..2000).map { it.toString() }

    override suspend fun doRequest(record: String): String = httpClient.get {
        url("http://localhost:$MOCK_SERVER_PORT/person")
    }

    companion object {
        private const val MOCK_SERVER_PORT = 10800
        private lateinit var mockServer: ClientAndServer

        @JvmStatic
        @BeforeAll
        fun beforeAll() {
            mockServer = ClientAndServer.startClientAndServer(MOCK_SERVER_PORT).apply {
                `when`(request().withMethod("GET").withPath("/person"))
                        .respond(response()
                                .withDelay(Delay.milliseconds(Random.nextLong(5, 10)))
                                .withStatusCode(200)
                                .withBody("""{"person": "Good boy!"}"""))
            }
        }
    }
}
