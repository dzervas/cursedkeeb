# CursedKeeb Firmware

The target MCU is an ESP32S3.

To build & flash:

```bash
podman run --rm -it --device /dev/ttyACM0 -v $(pwd):/home/esp/work --userns=keep-id --workdir /home/esp/work espressif/idf-rust:esp32s3_latest cargo run --release
```
