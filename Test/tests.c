#include <setjmp.h>
#include <stdarg.h>
#include <stddef.h>

#include <cmocka.h>

void null_test_success(void **state) {}

void null_test_fail(void **state) { assert_true(0); }

/* These functions will be used to initialize
   and clean resources up after each test run */
int setup(void **state) { return 0; }

int teardown(void **state) { return 0; }

int main(void) {
  const struct CMUnitTest tests[] = {
      cmocka_unit_test(null_test_success),
      cmocka_unit_test(null_test_fail),
  };

  /* If setup and teardown functions are not
     needed, then NULL may be passed instead */

  int count_fail_tests = cmocka_run_group_tests(tests, setup, teardown);

  return count_fail_tests;
}
