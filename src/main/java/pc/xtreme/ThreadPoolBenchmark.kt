package pc.xtreme

import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.asCoroutineDispatcher
import java.util.concurrent.Executors

@ExperimentalCoroutinesApi
abstract class ThreadPoolBenchmark<Record, Result> : BaseBenchmark<Record, Result>() {

    private val dispatcher by lazy { Executors.newFixedThreadPool(concurrency).asCoroutineDispatcher() }

    override fun onStop() {
        dispatcher.close()
        super.onStop()
    }
}