#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(void)
{
  int n = getNumFreePages();
  printf(1,"%d\n",n);
  exit();
}
