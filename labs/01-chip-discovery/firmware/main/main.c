#include <stdio.h>

#include "esp_chip_info.h"
#include "esp_flash.h"

void app_main(void)
{
    esp_chip_info_t chip_info;
    uint32_t flash_size = 0;

    esp_chip_info(&chip_info);
    esp_flash_get_size(NULL, &flash_size);

    printf("\n=== Cyber Quanta Staj Laboratuvari ===\n");
    printf("Ilk firmware basariyla calisti.\n");
    printf("CPU cekirdegi: %d\n", chip_info.cores);
    printf("Cip revizyonu: %d.%d\n",
           chip_info.revision / 100,
           chip_info.revision % 100);
    printf("Flash boyutu: %lu MB\n",
           (unsigned long)(flash_size / (1024 * 1024)));
    printf("======================================\n");
}
