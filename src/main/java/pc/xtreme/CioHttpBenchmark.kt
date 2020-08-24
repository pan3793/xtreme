package pc.xtreme

import io.ktor.client.HttpClient
import io.ktor.client.engine.cio.CIO
import io.ktor.client.engine.cio.endpoint
import io.ktor.util.KtorExperimentalAPI
import io.micrometer.core.instrument.Metrics
import io.micrometer.core.instrument.Timer
import kotlinx.coroutines.Deferred
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.async
import java.time.Duration

@KtorExperimentalAPI
@ExperimentalCoroutinesApi
abstract class CioHttpBenchmark<Record, Result> : BaseBenchmark<Record, Result>() {

    abstract val timeout: Duration

    val httpClient by lazy {
        HttpClient(CIO) {
            expectSuccess = true
            engine {
                maxConnectionsCount = concurrency
                requestTimeout = timeout.toMillis()
                endpoint {
                    maxConnectionsPerRoute = concurrency
                    connectTimeout = timeout.toMillis()
                    keepAliveTime = timeout.toMillis()
                    pipelining = true
                    pipelineMaxSize = 1
                    threadsCount = 1
                }
            }
        }
    }

    override fun consumeAsync(record: Record): Deferred<Result> {
        val sample = Timer.start()
        val request = GlobalScope.async { doRequest(record) }
        request.invokeOnCompletion { cause ->
            if (cause != null)
                log.error("query {} error: {}", record, cause.message)
            sample.stop(Metrics.timer("query_execute_duration"))
        }
        return request
    }

    abstract suspend fun doRequest(record: Record): Result
}