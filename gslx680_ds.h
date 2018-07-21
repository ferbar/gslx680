/*
 * Touchscreen driver for Silead GSLx680
 *
 * Copyright (C) 2014 Johann Glaser
 */
/*
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 2 of the License, or (at your option)
 * any later version.
 */

#ifndef __GSLX680_DS_H
#define __GSLX680_DS_H

#define GSLX680_DRV_NAME "gslX680"

struct gslx680_platform_data {
  unsigned int irq;    // GPIO for IRQ pin
  unsigned int rst;    // GPIO for Reset pin
};

#define SCREEN_MAX_X 		1366
#define SCREEN_MAX_Y 		768

#define MAX_FINGERS 		10
#define MAX_CONTACTS 		10

//#define 	GSL_NOID_VERSION

#ifdef	GSL_NOID_VERSION

struct gsl_touch_info
{
	int x[MAX_FINGERS];
	int y[MAX_FINGERS];
	int id[MAX_FINGERS];
	int finger_num;
};
extern unsigned int gsl_mask_tiaoping(void);
extern unsigned int gsl_version_id(void);
extern void gsl_alg_id_main(struct gsl_touch_info *cinfo);
extern void gsl_DataInit(int *ret);

#endif // GSL_NOID_VERSION

struct fw_data
{
    u32 offset : 8;
    u32 : 0;
    u32 val;
};

#endif // __GSLX680_DS_H
