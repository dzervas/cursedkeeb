# CursedKeeb

A "mechanical" keyboard with 14mm pushbuttons and an ESP32S3.

## Building

```bash
podman run --rm -it --device /dev/ttyACM0 -v $(pwd)/firmware:/home/esp/work --userns=keep-id --workdir /home/esp/work espressif/idf-rust:esp32s3_latest
```

Then run:

```bash
cargo run --release
```

## Case & keycaps

Unfortunately, the only "valid" CAD for me on Linux is OnShape.

So [here](https://cad.onshape.com/documents/0845c557513bbe8a62a257c4/w/b7745e471183c45c479d96b2/e/a8a4abefaaf00c58193a5302)'s the assembly of the case and keycaps, targeted for 3D printing.
