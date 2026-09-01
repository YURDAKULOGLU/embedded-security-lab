# Teknik Terimler Sözlüğü

Bu sözlük laboratuvarda karşılaşılan sektör terimlerini ilk kullanıldıkları bağlamla birlikte kaydeder. Yeni terimler açıklanmadan sonraki deney aşamasına geçilmez.

## Boot

Bir cihazın güç verildikten veya resetlendikten sonra çalışır hâle gelme sürecidir.

## ROM

`Read-Only Memory`, yani salt okunur bellek. ESP32-C3 üretilirken çipin içine yerleştirilen ilk açılış kodunu içerir. Normal flashlama işlemiyle değiştirilemez.

## Bootloader

`Boot loader`, yani açılış yükleyicisi. Ana uygulamadan önce çalışan küçük programdır. Donanımı başlangıç durumuna getirir, partition tablosunu okur, çalıştırılacak uygulamayı bulur ve ona kontrolü devreder.

## Flash bellek

Elektrik kesildiğinde içeriğini koruyan kalıcı bellektir. Bootloader, partition tablosu ve uygulama firmware'i burada farklı adreslerde tutulur.

## Partition

Flash belleğin belirli bir amaç için ayrılmış mantıksal bölümüdür. Uygulama, ayarlar veya OTA güncelleme kopyaları için farklı partition'lar kullanılabilir.

## Partition tablosu

Flash bellekte hangi partition'ın hangi adreste başladığını, ne kadar büyük olduğunu ve ne amaçla kullanılacağını belirten veri tablosudur. Çalışan bir program değildir; bootloader tarafından okunur.

## Firmware

Bir donanım cihazını yöneten yazılımdır. ESP32-C3 laboratuvarında derlediğimiz uygulama ve açılış bileşenleri firmware bütününün parçalarıdır.

## Adres

Bellekteki bir konumun sayısal kimliğidir. Örneğin `0x10000`, uygulama firmware'inin flash bellekte başladığı konumu belirtir.

## Offset

Bir başlangıç noktasına göre uzaklıktır. Flashlama bağlamında çoğunlukla flash belleğin başlangıcından itibaren yazılacak konumu ifade eder.

## `app_main`

ESP-IDF uygulamasının kullanıcı koduna ait başlangıç fonksiyonudur. Boot sürecinden sonra ESP-IDF çalışma ortamı tarafından çağrılır.
