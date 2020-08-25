package pc.xtreme

import io.ktor.client.request.*
import io.ktor.util.*
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.runBlocking
import okhttp3.mockwebserver.Dispatcher
import okhttp3.mockwebserver.MockResponse
import okhttp3.mockwebserver.MockWebServer
import okhttp3.mockwebserver.RecordedRequest
import org.junit.jupiter.api.BeforeAll
import org.junit.jupiter.api.Test
import java.time.Duration
import java.util.concurrent.TimeUnit
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
    override val qps: Int = 100
    override val timeout: Duration = Duration.ofSeconds(10)

    override fun source(): Iterable<String> = (1..2000).map { it.toString() }

    override suspend fun doRequest(record: String): String = httpClient.get {
        url(mockServer.url("/person").toString())
    }

    companion object {
        private val mockServer: MockWebServer = MockWebServer()

        @JvmStatic
        @BeforeAll
        fun beforeAll() {
            mockServer.dispatcher = object : Dispatcher() {
                override fun dispatch(request: RecordedRequest): MockResponse =
                        when (request.method.toUpperCase() to request.path) {
                            "GET" to "/person" ->
                                MockResponse()
                                        .setBodyDelay(Random.nextLong(5, 10), TimeUnit.MILLISECONDS)
                                        .setBody("""{"person": "Good boy!"}""")
                            else -> MockResponse().setResponseCode(404)
                        }
            }
        }
    }
}
