#################################################################
# Makefile generated by Xilinx Platform Studio 
# Project:/data/casper/mlib_devel_cbass/c09f12_01/XPS_ROACH_base/system.xmp
#
# WARNING : This file will be re-generated every time a command
# to run a make target is invoked. So, any changes made to this  
# file manually, will be lost when make is invoked next. 
#################################################################

XILINX_EDK_DIR = /opt/xilinx/14.7/ISE_DS/EDK

SYSTEM = system

MHSFILE = system.mhs

FPGA_ARCH = virtex5

DEVICE = xc5vsx95tff1136-1

INTSTYLE = default

XPS_HDL_LANG = vhdl
GLOBAL_SEARCHPATHOPT = 
PROJECT_SEARCHPATHOPT = 

SEARCHPATHOPT = $(PROJECT_SEARCHPATHOPT) $(GLOBAL_SEARCHPATHOPT)

SUBMODULE_OPT = 

PLATGEN_OPTIONS = -p $(DEVICE) -lang $(XPS_HDL_LANG) -intstyle $(INTSTYLE) $(SEARCHPATHOPT) $(SUBMODULE_OPT) -msg __xps/ise/xmsgprops.lst

OBSERVE_PAR_OPTIONS = -error yes

MICROBLAZE_BOOTLOOP = $(XILINX_EDK_DIR)/sw/lib/microblaze/mb_bootloop.elf
MICROBLAZE_BOOTLOOP_LE = $(XILINX_EDK_DIR)/sw/lib/microblaze/mb_bootloop_le.elf
PPC405_BOOTLOOP = $(XILINX_EDK_DIR)/sw/lib/ppc405/ppc_bootloop.elf
PPC440_BOOTLOOP = $(XILINX_EDK_DIR)/sw/lib/ppc440/ppc440_bootloop.elf
BOOTLOOP_DIR = bootloops

BRAMINIT_ELF_IMP_FILES =
BRAMINIT_ELF_IMP_FILE_ARGS =

BRAMINIT_ELF_SIM_FILES =
BRAMINIT_ELF_SIM_FILE_ARGS =

SIM_CMD = xterm -e ./isim_system

BEHAVIORAL_SIM_SCRIPT = simulation/behavioral/$(SYSTEM)_setup.tcl

STRUCTURAL_SIM_SCRIPT = simulation/structural/$(SYSTEM)_setup.tcl

TIMING_SIM_SCRIPT = simulation/timing/$(SYSTEM)_setup.tcl

DEFAULT_SIM_SCRIPT = $(BEHAVIORAL_SIM_SCRIPT)

SIMGEN_OPTIONS = -p $(DEVICE) -lang $(XPS_HDL_LANG) -intstyle $(INTSTYLE) $(SEARCHPATHOPT) $(BRAMINIT_ELF_SIM_FILE_ARGS) -msg __xps/ise/xmsgprops.lst -s isim


CORE_STATE_DEVELOPMENT_FILES = pcores/bram_block_custom_v1_00_a/netlist/dummy.edn \
pcores/bram_block_custom_v1_00_a/netlist/dummy.edn \
pcores/bram_block_custom_v1_00_a/netlist/dummy.edn \
pcores/bram_block_custom_v1_00_a/netlist/dummy.edn \
pcores/kat_ten_gb_eth_v1_00_a/netlist/arp_cache.ngc \
pcores/kat_ten_gb_eth_v1_00_a/netlist/cpu_buffer.ngc \
pcores/kat_ten_gb_eth_v1_00_a/netlist/rx_packet_ctrl_fifo.ngc \
pcores/kat_ten_gb_eth_v1_00_a/netlist/rx_packet_fifo_bram.ngc \
pcores/kat_ten_gb_eth_v1_00_a/netlist/rx_packet_fifo_dist.ngc \
pcores/kat_ten_gb_eth_v1_00_a/netlist/tx_cpu_fifo.ngc \
pcores/kat_ten_gb_eth_v1_00_a/netlist/tx_cpu_size_fifo.ngc \
pcores/kat_ten_gb_eth_v1_00_a/netlist/tx_packet_ctrl_fifo.ngc \
pcores/kat_ten_gb_eth_v1_00_a/netlist/tx_packet_fifo.ngc \
pcores/kat_ten_gb_eth_v1_00_a/netlist/tx_fifo_ext.ngc \
pcores/xaui_phy_v1_00_a/netlist/xaui_v7_2.ngc \
pcores/kat_adc_interface_v1_00_a/netlist/adc_async_fifo.ngc \
pcores/kat_adc_iic_controller_v1_00_a/netlist/cpu_op_fifo.ngc \
pcores/kat_adc_iic_controller_v1_00_a/netlist/rx_fifo.ngc \
pcores/kat_adc_iic_controller_v1_00_a/netlist/fab_op_fifo.ngc \
pcores/bram_block_custom_v1_00_a/netlist/dummy.edn \
pcores/opb_katadccontroller_v1_00_a/hdl/verilog/opb_katadccontroller.v \
pcores/opb_katadccontroller_v1_00_a/hdl/verilog/opb_attach.v \
pcores/opb_katadccontroller_v1_00_a/hdl/verilog/serial_config.v \
pcores/opb_katadccontroller_v1_00_a/hdl/verilog/autoconfig.v \
pcores/roach_infrastructure_v1_00_a/hdl/verilog/roach_infrastructure.v \
pcores/reset_block_v1_00_a/hdl/verilog/reset_block.v \
pcores/epb_opb_bridge_v1_00_a/hdl/verilog/epb_opb_bridge.v \
pcores/epb_infrastructure_v1_00_a/hdl/verilog/epb_infrastructure.v \
pcores/sys_block_v1_00_a/hdl/verilog/sys_block.v \
pcores/xaui_infrastructure_v1_00_a/hdl/verilog/xaui_infrastructure.v \
pcores/xaui_infrastructure_v1_00_a/hdl/verilog/transceiver_bank.v \
pcores/xaui_infrastructure_v1_00_a/hdl/verilog/transceiver.v \
pcores/opb_register_ppc2simulink_v1_00_a/hdl/verilog/opb_register_ppc2simulink.v \
pcores/bram_block_custom_v1_00_a/hdl/verilog/bram_block_custom.v \
pcores/bram_block_custom_v1_00_a/hdl/verilog/bram.v \
pcores/opb_register_simulink2ppc_v1_00_a/hdl/verilog/opb_register_simulink2ppc.v \
pcores/kat_ten_gb_eth_v1_00_a/hdl/verilog/arp_cache.v \
pcores/kat_ten_gb_eth_v1_00_a/hdl/verilog/cpu_buffer.v \
pcores/kat_ten_gb_eth_v1_00_a/hdl/verilog/kat_ten_gb_eth.v \
pcores/kat_ten_gb_eth_v1_00_a/hdl/verilog/opb_attach.v \
pcores/kat_ten_gb_eth_v1_00_a/hdl/verilog/rx_packet_ctrl_fifo.v \
pcores/kat_ten_gb_eth_v1_00_a/hdl/verilog/rx_packet_fifo_bram.v \
pcores/kat_ten_gb_eth_v1_00_a/hdl/verilog/rx_packet_fifo_dist.v \
pcores/kat_ten_gb_eth_v1_00_a/hdl/verilog/tge_rx.v \
pcores/kat_ten_gb_eth_v1_00_a/hdl/verilog/tge_tx.v \
pcores/kat_ten_gb_eth_v1_00_a/hdl/verilog/tx_packet_ctrl_fifo.v \
pcores/kat_ten_gb_eth_v1_00_a/hdl/verilog/tx_packet_fifo.v \
pcores/kat_ten_gb_eth_v1_00_a/hdl/verilog/tx_fifo_ext.v \
pcores/kat_ten_gb_eth_v1_00_a/hdl/verilog/ten_gig_eth_mac.v \
pcores/kat_ten_gb_eth_v1_00_a/hdl/verilog/mac_rx.v \
pcores/kat_ten_gb_eth_v1_00_a/hdl/verilog/mac_tx.v \
pcores/kat_ten_gb_eth_v1_00_a/hdl/verilog/mac_hard_crc.v \
pcores/xaui_phy_v1_00_a/hdl/verilog/xaui_phy.v \
pcores/xaui_phy_v1_00_a/hdl/verilog/xaui_v7_2.v \
pcores/xaui_phy_v1_00_a/hdl/verilog/deskew_state.v \
pcores/xaui_phy_v1_00_a/hdl/verilog/fix_term.v \
pcores/xaui_phy_v1_00_a/hdl/verilog/pcs_deskew.v \
pcores/xaui_phy_v1_00_a/hdl/verilog/pcs_rx.v \
pcores/xaui_phy_v1_00_a/hdl/verilog/pcs_sync.v \
pcores/xaui_phy_v1_00_a/hdl/verilog/pcs_tx.v \
pcores/xaui_phy_v1_00_a/hdl/verilog/sync_state.v \
pcores/xaui_phy_v1_00_a/hdl/verilog/tx_state.v \
pcores/xaui_phy_v1_00_a/hdl/verilog/xaui_kat.v \
pcores/xaui_phy_v1_00_a/hdl/verilog/xaui_kat.vh \
pcores/kat_adc_interface_v1_00_a/hdl/verilog/adc_async_fifo.v \
pcores/kat_adc_interface_v1_00_a/hdl/verilog/kat_adc_interface.v \
pcores/kat_adc_iic_controller_v1_00_a/hdl/verilog/kat_adc_iic_controller.v \
pcores/kat_adc_iic_controller_v1_00_a/hdl/verilog/miic_ops.v \
pcores/kat_adc_iic_controller_v1_00_a/hdl/verilog/gain_set.v \
pcores/kat_adc_iic_controller_v1_00_a/hdl/verilog/opb_attach.v \
pcores/kat_adc_iic_controller_v1_00_a/hdl/verilog/cpu_op_fifo.v \
pcores/kat_adc_iic_controller_v1_00_a/hdl/verilog/fab_op_fifo.v \
pcores/kat_adc_iic_controller_v1_00_a/hdl/verilog/rx_fifo.v \
pcores/iic_infrastructure_v1_00_a/hdl/verilog/iic_infrastructure.v \
pcores/gpio_simulink2ext_v1_00_a/hdl/vhdl/gpio_simulink2ext.vhd \
pcores/qdr_controller_v1_00_a/hdl/verilog/qdr_controller.v \
pcores/qdr_controller_v1_00_a/hdl/verilog/qdrc_top.v \
pcores/qdr_controller_v1_00_a/hdl/verilog/qdrc_infrastructure.v \
pcores/qdr_controller_v1_00_a/hdl/verilog/qdrc_phy.v \
pcores/qdr_controller_v1_00_a/hdl/verilog/qdrc_phy_bit_align.v \
pcores/qdr_controller_v1_00_a/hdl/verilog/qdrc_phy_bit_correct.v \
pcores/qdr_controller_v1_00_a/hdl/verilog/qdrc_phy_bit_train.v \
pcores/qdr_controller_v1_00_a/hdl/verilog/qdrc_phy_burst_align.v \
pcores/qdr_controller_v1_00_a/hdl/verilog/qdrc_phy_sm.v \
pcores/qdr_controller_v1_00_a/hdl/verilog/qdrc_rd.v \
pcores/qdr_controller_v1_00_a/hdl/verilog/qdrc_wr.v \
pcores/opb_qdr_sniffer_v1_00_a/hdl/verilog/opb_qdr_sniffer.v \
pcores/opb_qdr_sniffer_v1_00_a/hdl/verilog/async_qdr_interface.v \
pcores/opb_qdr_sniffer_v1_00_a/hdl/verilog/async_qdr_interface36.v \
pcores/opb_qdr_sniffer_v1_00_a/hdl/verilog/qdr_config.v

WRAPPER_NGC_FILES = implementation/system_opb_katadccontroller_0_wrapper.ngc \
implementation/system_infrastructure_inst_wrapper.ngc \
implementation/system_reset_block_inst_wrapper.ngc \
implementation/system_opb0_wrapper.ngc \
implementation/system_epb_opb_bridge_inst_wrapper.ngc \
implementation/system_epb_infrastructure_inst_wrapper.ngc \
implementation/system_sys_block_inst_wrapper.ngc \
implementation/system_xaui_infrastructure_inst_wrapper.ngc \
implementation/system_c09f12_01_a0_fd0_wrapper.ngc \
implementation/system_c09f12_01_a0_fd1_wrapper.ngc \
implementation/system_c09f12_01_a1_fd0_wrapper.ngc \
implementation/system_c09f12_01_a1_fd1_wrapper.ngc \
implementation/system_c09f12_01_adc_ctrl0_wrapper.ngc \
implementation/system_c09f12_01_adc_ctrl1_wrapper.ngc \
implementation/system_c09f12_01_adc_snap0_bram_ramblk_wrapper.ngc \
implementation/system_c09f12_01_adc_snap0_bram_wrapper.ngc \
implementation/system_c09f12_01_adc_snap0_ctrl_wrapper.ngc \
implementation/system_c09f12_01_adc_snap0_status_wrapper.ngc \
implementation/system_c09f12_01_adc_snap0_tr_en_cnt_wrapper.ngc \
implementation/system_c09f12_01_adc_snap0_trig_offset_wrapper.ngc \
implementation/system_c09f12_01_adc_snap0_val_wrapper.ngc \
implementation/system_c09f12_01_adc_snap1_bram_ramblk_wrapper.ngc \
implementation/system_c09f12_01_adc_snap1_bram_wrapper.ngc \
implementation/system_c09f12_01_adc_snap1_ctrl_wrapper.ngc \
implementation/system_c09f12_01_adc_snap1_status_wrapper.ngc \
implementation/system_c09f12_01_adc_snap1_tr_en_cnt_wrapper.ngc \
implementation/system_c09f12_01_adc_snap1_trig_offset_wrapper.ngc \
implementation/system_c09f12_01_adc_snap1_val_wrapper.ngc \
implementation/system_c09f12_01_adc_sum_sq0_wrapper.ngc \
implementation/system_c09f12_01_adc_sum_sq1_wrapper.ngc \
implementation/system_c09f12_01_board_id_wrapper.ngc \
implementation/system_c09f12_01_clk_frequency_wrapper.ngc \
implementation/system_c09f12_01_coarse_ctrl_wrapper.ngc \
implementation/system_c09f12_01_coarse_delay0_wrapper.ngc \
implementation/system_c09f12_01_coarse_delay1_wrapper.ngc \
implementation/system_c09f12_01_control_wrapper.ngc \
implementation/system_c09f12_01_delay_tr_status0_wrapper.ngc \
implementation/system_c09f12_01_delay_tr_status1_wrapper.ngc \
implementation/system_c09f12_01_eq0_ramblk_wrapper.ngc \
implementation/system_c09f12_01_eq0_wrapper.ngc \
implementation/system_c09f12_01_eq1_ramblk_wrapper.ngc \
implementation/system_c09f12_01_eq1_wrapper.ngc \
implementation/system_c09f12_01_fine_ctrl_wrapper.ngc \
implementation/system_c09f12_01_fstatus0_wrapper.ngc \
implementation/system_c09f12_01_fstatus1_wrapper.ngc \
implementation/system_c09f12_01_gbe0_wrapper.ngc \
implementation/system_xaui_phy_0_wrapper.ngc \
implementation/system_c09f12_01_gbe_ip0_wrapper.ngc \
implementation/system_c09f12_01_gbe_port_wrapper.ngc \
implementation/system_c09f12_01_gbe_tx_cnt0_wrapper.ngc \
implementation/system_c09f12_01_gbe_tx_err_cnt0_wrapper.ngc \
implementation/system_c09f12_01_katadc0_wrapper.ngc \
implementation/system_iic_adc0_wrapper.ngc \
implementation/system_iic_infrastructure_adc0_wrapper.ngc \
implementation/system_c09f12_01_ld_time_lsw0_wrapper.ngc \
implementation/system_c09f12_01_ld_time_lsw1_wrapper.ngc \
implementation/system_c09f12_01_ld_time_msw0_wrapper.ngc \
implementation/system_c09f12_01_ld_time_msw1_wrapper.ngc \
implementation/system_c09f12_01_leds_roach_gpioa0_wrapper.ngc \
implementation/system_c09f12_01_leds_roach_gpioa1_wrapper.ngc \
implementation/system_c09f12_01_leds_roach_gpioa2_wrapper.ngc \
implementation/system_c09f12_01_leds_roach_gpioa3_wrapper.ngc \
implementation/system_c09f12_01_leds_roach_gpioa4_wrapper.ngc \
implementation/system_c09f12_01_leds_roach_gpioa5_wrapper.ngc \
implementation/system_c09f12_01_leds_roach_gpioa6_wrapper.ngc \
implementation/system_c09f12_01_leds_roach_gpioa7_wrapper.ngc \
implementation/system_c09f12_01_leds_roach_gpioa_oe_wrapper.ngc \
implementation/system_c09f12_01_leds_roach_led0_wrapper.ngc \
implementation/system_c09f12_01_leds_roach_led1_wrapper.ngc \
implementation/system_c09f12_01_leds_roach_led2_wrapper.ngc \
implementation/system_c09f12_01_leds_roach_led3_wrapper.ngc \
implementation/system_c09f12_01_mcount_lsw_wrapper.ngc \
implementation/system_c09f12_01_mcount_msw_wrapper.ngc \
implementation/system_c09f12_01_pps_count_wrapper.ngc \
implementation/system_qdr0_controller_wrapper.ngc \
implementation/system_qdr0_sniffer_wrapper.ngc \
implementation/system_c09f12_01_rcs_app_wrapper.ngc \
implementation/system_c09f12_01_rcs_lib_wrapper.ngc \
implementation/system_c09f12_01_rcs_user_wrapper.ngc \
implementation/system_c09f12_01_snap_debug_addr_wrapper.ngc \
implementation/system_c09f12_01_snap_debug_bram_ramblk_wrapper.ngc \
implementation/system_c09f12_01_snap_debug_bram_wrapper.ngc \
implementation/system_c09f12_01_snap_debug_ctrl_wrapper.ngc \
implementation/system_c09f12_01_trig_level_wrapper.ngc \
implementation/system_opb1_wrapper.ngc \
implementation/system_opb2opb_bridge_opb1_wrapper.ngc

POSTSYN_NETLIST = implementation/$(SYSTEM).ngc

SYSTEM_BIT = implementation/$(SYSTEM).bit

DOWNLOAD_BIT = implementation/download.bit

SYSTEM_ACE = implementation/$(SYSTEM).ace

UCF_FILE = data/system.ucf

BMM_FILE = implementation/$(SYSTEM).bmm

BITGEN_UT_FILE = etc/bitgen.ut

XFLOW_OPT_FILE = etc/fast_runtime.opt
XFLOW_DEPENDENCY = __xps/xpsxflow.opt $(XFLOW_OPT_FILE)

XPLORER_DEPENDENCY = __xps/xplorer.opt
XPLORER_OPTIONS = -p $(DEVICE) -uc $(SYSTEM).ucf -bm $(SYSTEM).bmm -max_runs 7

FPGA_IMP_DEPENDENCY = $(BMM_FILE) $(POSTSYN_NETLIST) $(UCF_FILE) $(XFLOW_DEPENDENCY)

SDK_EXPORT_DIR = SDK/SDK_Export/hw
SYSTEM_HW_HANDOFF = $(SDK_EXPORT_DIR)/$(SYSTEM).xml
SYSTEM_HW_HANDOFF_BIT = $(SDK_EXPORT_DIR)/$(SYSTEM).bit
SYSTEM_HW_HANDOFF_DEP = $(SYSTEM_HW_HANDOFF) $(SYSTEM_HW_HANDOFF_BIT)
