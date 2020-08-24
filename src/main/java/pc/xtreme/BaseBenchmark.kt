package pc.xtreme

import com.google.common.util.concurrent.RateLimiter
import io.micrometer.core.instrument.Metrics
import io.micrometer.core.instrument.logging.LoggingMeterRegistry
import kotlinx.coroutines.*
import kotlinx.coroutines.channels.produce
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import pc.xtreme.util.IoUtil
import java.net.InetAddress
import java.time.Duration

@ExperimentalCoroutinesApi
abstract class BaseBenchmark<Record, Result> {
    init {
        val metricLogger: Logger = LoggerFactory.getLogger("metrics")
        val loggingMeterRegistry = LoggingMeterRegistry
                .builder { key ->
                    when (key) {
                        "logging.step" -> Duration.ofSeconds(3).toString()
                        "logging.logInactive" -> "false"
                        else -> null
                    }
                }
                .loggingSink { msg -> metricLogger.info(msg) }
                .build()
        Metrics.addRegistry(loggingMeterRegistry)
        Metrics.globalRegistry.config().commonTags("hostname", InetAddress.getLocalHost().hostName)
    }

    abstract val qps: Int
    abstract val concurrency: Int

    open val bufferSize = 1024

    abstract fun source(): Iterable<Record>

    abstract fun consumeAsync(record: Record): Deferred<Result>

    open fun onStart() {
        log.info("benchmark start with concurrency:$concurrency qps:$qps")
    }

    open fun onStop() {
        log.info("benchmark completed.")
    }

    val log: Logger = LoggerFactory.getLogger("main")


    open suspend fun run() {
        onStart()

        val inboundChannel = GlobalScope.produce(Dispatchers.IO, bufferSize) {
            val rl = RateLimiter.create(qps.toDouble())
            for (record in source()) {
                rl.acquire()
                send(record)
            }
        }

        val outboundChannel = GlobalScope.produce(Dispatchers.IO, bufferSize) {
            for (record in inboundChannel) {
                log.debug("send record: {}", record)
                send(consumeAsync(record))
            }
        }

        val resultJob = GlobalScope.launch {
            for (result in outboundChannel) {
                log.debug("result: {}", result.await())
            }
        }
        resultJob.join()
        onStop()
    }

    /**
     * return list[file_name, file_content]
     */
    fun loadFiles(folder: String, ext: String): List<Pair<String, String>> =
            IoUtil.loadResources("classpath:$folder/*.$ext")
                    .map { Pair(it.filename, it.inputStream.bufferedReader().readText()) }
}