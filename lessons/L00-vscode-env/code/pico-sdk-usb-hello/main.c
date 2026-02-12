#include <stdio.h>

#include "pico/stdlib.h"

int main(void) {
    stdio_init_all();

    // Give USB serial a brief moment to enumerate on the host.
    sleep_ms(2000);

    int count = 0;
    while (true) {
        printf("L00 Pico SDK smoke test tick %d\\n", count++);
        sleep_ms(1000);
    }
}
