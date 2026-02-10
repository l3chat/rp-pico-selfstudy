#include <stdio.h>

#include "pico/stdlib.h"

int main(void) {
    stdio_init_all();

    // Give USB serial time to enumerate on host.
    sleep_ms(2000);

    puts("L00 Pico SDK hello");

    unsigned long counter = 0;
    while (true) {
        printf("tick: %lu\n", counter++);
        sleep_ms(1000);
    }
}
