package pc.xtreme.util

import java.util.*
import java.util.stream.Collectors
import java.util.stream.Stream
import kotlin.collections.HashMap

object CollectionUtil {

    fun <T> concat(first: List<T>, second: List<T>): List<T> {
        return Stream.concat(first.stream(), second.stream()).collect(Collectors.toList())
    }

    @SafeVarargs
    fun <T> concat(originList: List<T>, vararg elements: T): List<T> {
        return Stream.concat(originList.stream(), Stream.of(*elements)).collect(Collectors.toList())
    }

    fun <T> repeat(time: Int, origin: List<T>): List<T> {
        require(time > 0)
        var result = origin
        for (i in 0 until time - 1) {
            result = concat(result, origin)
        }
        return result
    }

    fun filterIgnoreCase(set: List<String>, keyword: String): List<String> =
            set.filter { key: String -> key.equals(keyword, ignoreCase = true) }

    fun filterKeyIgnoreCase(properties: Properties, keyword: String): Map<String, String> {
        val props: MutableMap<String, String> = HashMap()
        properties.forEach { k: Any, v: Any -> props[k.toString()] = v.toString() }
        return filterKeyIgnoreCase(props, keyword)
    }

    fun <V> filterKeyIgnoreCase(map: Map<String, V>, keyword: String): Map<String, V> =
            map.filterKeys { !it.equals(keyword, ignoreCase = true) }

    fun <K, V> mergeMapKeepFirst(one: Map<K, V>, other: Map<K, V>): Map<K, V> =
            Stream.concat(one.entries.stream(), other.entries.stream()).collect(
                    Collectors.toMap(
                            { entry: Map.Entry<K, V> -> entry.key },
                            { entry: Map.Entry<K, V> -> entry.value },
                            { former: V, _: V -> former }))

    fun <K, V> mergeMapKeepLast(one: Map<K, V>, other: Map<K, V>): Map<K, V> =
            Stream.concat(one.entries.stream(), other.entries.stream()).collect(
                    Collectors.toMap(
                            { entry: Map.Entry<K, V> -> entry.key },
                            { entry: Map.Entry<K, V> -> entry.value },
                            { _: V, latter: V -> latter }))
}