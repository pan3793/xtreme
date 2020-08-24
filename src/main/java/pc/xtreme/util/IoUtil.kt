package pc.xtreme.util

import org.springframework.core.io.Resource
import org.springframework.core.io.support.PathMatchingResourcePatternResolver
import java.io.*
import java.nio.charset.StandardCharsets
import java.util.stream.Collectors

object IoUtil {
    val EOL = System.getProperty("line.separator")
    val SEP = File.separator

    private val RESOURCE_RESOLVER = PathMatchingResourcePatternResolver()

    fun readTextFromLocalFs(path: String): String {
        return readText(FileInputStream(path))
    }

    fun readTextFromClasspath(path: String): String {
        val classLoader: ClassLoader = Thread.currentThread().contextClassLoader ?: this.javaClass.classLoader
        return readText(classLoader.getResourceAsStream(path)!!)
    }

    fun readText(inputStream: InputStream): String = inputStream.use { it.bufferedReader().readText() }

    fun readText(resource: Resource): String = readText(resource.inputStream)

    fun readText(path: String): String = readText(loadResource(path))

    fun readTexts(path: String): Map<String, String> =
            loadResources(path).associate { resource -> resource.filename to readText(resource) }

    fun readLinesFromLocalFs(path: String): List<String> = readLines(FileInputStream(path))

    fun readLinesFromClasspath(path: String): List<String> {
        val classLoader: ClassLoader = Thread.currentThread().contextClassLoader ?: this.javaClass.classLoader
        return readLines(classLoader.getResourceAsStream(path)!!)
    }

    fun readLines(inputStream: InputStream): List<String> =
            BufferedReader(InputStreamReader(inputStream, StandardCharsets.UTF_8)).lines().collect(Collectors.toList())

    // Support pattern:
    //     file:/absolute_path/filename.ext
    //     file:relative_path/filename.ext
    //     classpath:path/filename.ext
    fun loadResource(path: String): Resource = RESOURCE_RESOLVER.getResource(path)

    // Support pattern:
    //     file:/absolute_path/**/file*.ext
    //     file:relative_path/file*.ext
    //     classpath:**/file*.ext
    fun loadResources(path: String): List<Resource> = RESOURCE_RESOLVER.getResources(path).toList()
}