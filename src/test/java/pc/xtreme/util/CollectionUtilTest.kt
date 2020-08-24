package pc.xtreme.util

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import java.util.*

class CollectionUtilTest {

    @Test
    fun testMergeMap() {
        val map1: MutableMap<String, String> = HashMap()
        map1["k1"] = "v1"
        map1["k2"] = "v2"
        val map2: MutableMap<String, String> = HashMap()
        map2["k2"] = "new_v2"
        map2["k3"] = "v3"
        val keepFirstMap: MutableMap<String, String> = HashMap()
        keepFirstMap["k1"] = "v1"
        keepFirstMap["k2"] = "v2"
        keepFirstMap["k3"] = "v3"
        val keepLastMap: MutableMap<String, String> = HashMap()
        keepLastMap["k1"] = "v1"
        keepLastMap["k2"] = "new_v2"
        keepLastMap["k3"] = "v3"
        assertEquals(keepFirstMap, CollectionUtil.mergeMapKeepFirst(map1, map2))
        assertEquals(keepLastMap, CollectionUtil.mergeMapKeepLast(map1, map2))
    }
}