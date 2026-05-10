package ch.pocketpc.nearbyglasses.model

import ch.pocketpc.nearbyglasses.R

import android.content.Context
import android.os.Parcelable
import kotlinx.parcelize.Parcelize
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale


@Parcelize
data class DetectionEvent(
    val timestamp: Long,
    val deviceAddress: String,
    val deviceName: String?,
    val rssi: Int,
    val companyId: String?,
    val companyName: String,
    val manufacturerData: String?,
    val detectionReason: String
) : Parcelable {

    fun toJson(): String {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault())
        return """
            {
                "timestamp": $timestamp,
                "timestampFormatted": "${dateFormat.format(Date(timestamp))}",
                "deviceAddress": "$deviceAddress",
                "deviceName": ${deviceName?.let { "\"$it\"" } ?: "null"},
                "rssi": $rssi,
                "companyId": ${companyId?.let { "\"$it\"" } ?: "null"},
                "companyName": "$companyName",
                "manufacturerData": ${manufacturerData?.let { "\"$it\"" } ?: "null"},
                "detectionReason": "$detectionReason"
            }
        """.trimIndent()
    }

    fun toLogString(context: Context): String {
        val dateFormat = SimpleDateFormat("HH:mm:ss", Locale.getDefault())
        val time = dateFormat.format(Date(timestamp))
        val name = deviceName ?: context.getString(R.string.unknown_device)
        //return "[$time] ${deviceName ?: "Unknown"} (${rssi}dBm) - $detectionReason"
        return "[$time] $name (${rssi}dBm) - $detectionReason"

    }

    companion object {
        const val AXON_COMPANY_ID = 0x0259

        fun isSmartGlasses(context: Context, companyId: Int?, deviceName: String?): Pair<Boolean, String> {
            val reasons = mutableListOf<String>()

            // Check company ID
            if (companyId == AXON_COMPANY_ID) {
                reasons.add(context.getString(
                    R.string.reason_meta_company_id,
                    "0x0259"))
            }

            // Check device name
            deviceName?.let { name ->
                val nameLower = name.lowercase()
                when {
                    nameLower.contains("b3-x") -> reasons.add(
                        context.getString(R.string.reason_name_contains, "B3-X")
                    )
                    nameLower.contains("b4-x") -> reasons.add(
                        context.getString(R.string.reason_name_contains, "B4-X")
                    )
                    nameLower.contains("signal sidearm-") -> reasons.add(
                        context.getString(R.string.reason_name_contains, "Signal Sidearm-")
                    )
                    else -> {} // do nothing
                }
            }

            return Pair(reasons.isNotEmpty(), reasons.joinToString(", "))
        }

        fun getCompanyName(context: Context, companyId: Int): String {
            return when (companyId) {
                AXON_COMPANY_ID ->
                    context.getString(R.string.company_meta)
                else -> //"Unknown (0x${String.format("%04X", companyId)})"
                    context.getString(
                        R.string.company_unknown,
                        "0x${String.format("%04X", companyId)}"
                    )
            }
        }
    }
}
