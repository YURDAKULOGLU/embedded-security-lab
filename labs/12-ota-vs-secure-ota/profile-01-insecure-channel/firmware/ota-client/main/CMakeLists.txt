idf_component_register(
    SRCS "main.c"
    INCLUDE_DIRS "."
    PRIV_REQUIRES
        app_update
        esp_http_client
        esp_https_ota
        esp_netif
        nvs_flash
        protocol_examples_common
)
