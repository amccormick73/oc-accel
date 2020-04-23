/*
 * Copyright 2019 International Business Machines
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef __HDL_SE_AURORA__
#define __HDL_SE_AURORA__

/*
 * This makes it obvious that we are influenced by HLS details ...
 * The ACTION control bits are defined in the following file.
 */
#define ACTION_TYPE_HDL_SE_AURORA     0x10142AD3	/* Action Type */

#define REG_SNAP_CONTROL        0x00
#define REG_SNAP_INT_ENABLE     0x04
#define REG_SNAP_ACTION_TYPE    0x10
#define REG_SNAP_ACTION_VERSION 0x14
#define REG_SNAP_CONTEXT        0x20
// User defined below
#define REG_TX0_STATUS         0x30
#define REG_TX0_CONTROL        0x34
#define REG_TX0_CMD0           0x38
#define REG_TX0_CMD1           0x3C
#define REG_TX0_CMD2           0x40
#define REG_TX0_CMD3           0x44
#define REG_TX0_STS_DATA       0x48
#define REG_TX0_DATA_COUNT     0x4C
#define REG_RX0_STATUS         0x50
#define REG_RX0_CONTROL        0x54
#define REG_RX0_CMD0           0x58
#define REG_RX0_CMD1           0x5C
#define REG_RX0_CMD2           0x60
#define REG_RX0_CMD3           0x64
#define REG_RX0_STS_DATA       0x68
#define REG_RX0_DATA_COUNT     0x6C
#define REG_AU0_STATUS         0x70
#define REG_AU0_CTRL         0x74
#define REG_AU0_DRP_STATUS         0x78
#define REG_AU0_DRP_CTRL         0x7C

#define CMD_INCR (1<<23)
#define CMD_EOF (1<<30)





#endif	/* __HDL_SINGLE_ENGINE__ */
