#include "ets_sys.h"
#include "osapi.h"
#include "gpio.h"
#include "os_type.h"
#include "user_interface.h"
#include "cpp_routines.h"
#include <stdlib.h>

static const int pin = 0;
static volatile os_timer_t some_timer;

void some_timerfunc(void *arg)
{
  //Do blinky stuff
  if (GPIO_REG_READ(GPIO_OUT_ADDRESS) & (1 << pin))
  {
    // set gpio low
    gpio_output_set(0, (1 << pin), 0, 0);
  }
  else
  {
    // set gpio high
    gpio_output_set((1 << pin), 0, 0, 0);
  }
}

void ICACHE_FLASH_ATTR init_done()
{
	os_printf("Init done!\n");
	// setup timer (500ms, repeating)
	os_timer_setfn(&some_timer, (os_timer_func_t *)some_timerfunc, NULL);
	os_timer_arm(&some_timer, 500, 1);
}

void ICACHE_FLASH_ATTR user_init()
{
  system_set_os_print(1);
  os_printf("Hello world!\n");
  do_global_ctors();
  // init gpio sussytem
  gpio_init();

  // configure UART TXD to be GPIO1, set as output
  PIN_FUNC_SELECT(PERIPHS_IO_MUX_GPIO0_U, FUNC_GPIO0);
  gpio_output_set(0, 0, (1 << pin), 0);

  system_init_done_cb(&init_done);
}
