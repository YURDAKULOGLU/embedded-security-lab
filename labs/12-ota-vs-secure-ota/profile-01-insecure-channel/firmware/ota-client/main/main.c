#include "esp_app_desc.h"
#include "esp_err.h"
#include "esp_event.h"
#include "esp_http_client.h"
#include "esp_https_ota.h"
#include "esp_log.h"
#include "esp_netif.h"
#include "esp_ota_ops.h"
#include "esp_system.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "nvs_flash.h"
#include "protocol_examples_common.h"
#include <inttypes.h>
#include <stdbool.h>

static const char *TAG = "insecure_ota";

static void initialize_nvs(void)
{
    esp_err_t result = nvs_flash_init();
    if (result == ESP_ERR_NVS_NO_FREE_PAGES || result == ESP_ERR_NVS_NEW_VERSION_FOUND) {
        ESP_ERROR_CHECK(nvs_flash_erase());
        result = nvs_flash_init();
    }
    ESP_ERROR_CHECK(result);
}

static void log_partition_state(void)
{
    const esp_partition_t *running = esp_ota_get_running_partition();
    const esp_partition_t *next = esp_ota_get_next_update_partition(NULL);
    const esp_app_desc_t *application = esp_app_get_description();

    ESP_LOGI(TAG, "Firmware version: %s", application->version);
    ESP_LOGI(TAG, "Running partition: %s at 0x%" PRIx32, running->label, running->address);
    if (next != NULL) {
        ESP_LOGI(TAG, "Passive update partition: %s at 0x%" PRIx32, next->label, next->address);
    }
}

void app_main(void)
{
    ESP_LOGW(TAG, "PROFILE_1_INSECURE_HTTP_OTA_CLIENT");
    ESP_LOGW(TAG, "HTTP provides no OTA server authentication or transport confidentiality.");

    initialize_nvs();
    log_partition_state();

    ESP_ERROR_CHECK(esp_netif_init());
    ESP_ERROR_CHECK(esp_event_loop_create_default());
    ESP_ERROR_CHECK(example_connect());

    ESP_LOGI(TAG, "Starting insecure OTA in %d seconds", CONFIG_LAB_OTA_START_DELAY_SECONDS);
    vTaskDelay(pdMS_TO_TICKS(CONFIG_LAB_OTA_START_DELAY_SECONDS * 1000));

    esp_http_client_config_t http_config = {
        .url = CONFIG_LAB_OTA_URL,
        .timeout_ms = 15000,
        .keep_alive_enable = true,
    };
    esp_https_ota_config_t ota_config = {
        .http_config = &http_config,
    };

    ESP_LOGW(TAG, "Downloading unauthenticated image from %s", CONFIG_LAB_OTA_URL);
    esp_err_t result = esp_https_ota(&ota_config);
    if (result == ESP_OK) {
        ESP_LOGW(TAG, "INSECURE_OTA_ACCEPTED_IMAGE");
        ESP_LOGI(TAG, "Restarting into the downloaded image");
        esp_restart();
    }

    ESP_LOGE(TAG, "OTA failed: %s", esp_err_to_name(result));
    while (true) {
        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}
