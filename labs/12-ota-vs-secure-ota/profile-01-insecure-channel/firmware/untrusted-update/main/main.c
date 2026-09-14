#include "esp_app_desc.h"
#include "esp_log.h"
#include "esp_ota_ops.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include <inttypes.h>
#include <stdbool.h>

static const char *TAG = "untrusted_update";

void app_main(void)
{
    const esp_partition_t *running = esp_ota_get_running_partition();
    const esp_app_desc_t *application = esp_app_get_description();

    ESP_LOGW(TAG, "UNTRUSTED_OTA_FIRMWARE_RUNNING");
    ESP_LOGI(TAG, "Firmware version: %s", application->version);
    ESP_LOGI(TAG, "Running partition: %s at 0x%" PRIx32, running->label, running->address);
    ESP_LOGW(TAG, "The device booted this image because image origin was not enforced.");

    while (true) {
        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}
