% c09f12_01/XSG core config
c09f12_01_XSG_core_config_type         = 'xps_xsg';
c09f12_01_XSG_core_config_param        = '';

% c09f12_01/a0_fd0
c09f12_01_a0_fd0_type         = 'xps_sw_reg';
c09f12_01_a0_fd0_param        = 'in';
c09f12_01_a0_fd0_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_a0_fd0_addr_start   = hex2dec('01000000');
c09f12_01_a0_fd0_addr_end     = hex2dec('010000FF');

% c09f12_01/a0_fd1
c09f12_01_a0_fd1_type         = 'xps_sw_reg';
c09f12_01_a0_fd1_param        = 'in';
c09f12_01_a0_fd1_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_a0_fd1_addr_start   = hex2dec('01000100');
c09f12_01_a0_fd1_addr_end     = hex2dec('010001FF');

% c09f12_01/a1_fd0
c09f12_01_a1_fd0_type         = 'xps_sw_reg';
c09f12_01_a1_fd0_param        = 'in';
c09f12_01_a1_fd0_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_a1_fd0_addr_start   = hex2dec('01000200');
c09f12_01_a1_fd0_addr_end     = hex2dec('010002FF');

% c09f12_01/a1_fd1
c09f12_01_a1_fd1_type         = 'xps_sw_reg';
c09f12_01_a1_fd1_param        = 'in';
c09f12_01_a1_fd1_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_a1_fd1_addr_start   = hex2dec('01000300');
c09f12_01_a1_fd1_addr_end     = hex2dec('010003FF');

% c09f12_01/adc_ctrl0
c09f12_01_adc_ctrl0_type         = 'xps_sw_reg';
c09f12_01_adc_ctrl0_param        = 'in';
c09f12_01_adc_ctrl0_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_adc_ctrl0_addr_start   = hex2dec('01000400');
c09f12_01_adc_ctrl0_addr_end     = hex2dec('010004FF');

% c09f12_01/adc_ctrl1
c09f12_01_adc_ctrl1_type         = 'xps_sw_reg';
c09f12_01_adc_ctrl1_param        = 'in';
c09f12_01_adc_ctrl1_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_adc_ctrl1_addr_start   = hex2dec('01000500');
c09f12_01_adc_ctrl1_addr_end     = hex2dec('010005FF');

% c09f12_01/adc_snap0/bram
c09f12_01_adc_snap0_bram_type         = 'xps_bram';
c09f12_01_adc_snap0_bram_param        = '1024';
c09f12_01_adc_snap0_bram_ip_name      = 'bram_if';
c09f12_01_adc_snap0_bram_addr_start   = hex2dec('01001000');
c09f12_01_adc_snap0_bram_addr_end     = hex2dec('01001FFF');

% c09f12_01/adc_snap0/ctrl
c09f12_01_adc_snap0_ctrl_type         = 'xps_sw_reg';
c09f12_01_adc_snap0_ctrl_param        = 'in';
c09f12_01_adc_snap0_ctrl_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_adc_snap0_ctrl_addr_start   = hex2dec('01002000');
c09f12_01_adc_snap0_ctrl_addr_end     = hex2dec('010020FF');

% c09f12_01/adc_snap0/status
c09f12_01_adc_snap0_status_type         = 'xps_sw_reg';
c09f12_01_adc_snap0_status_param        = 'out';
c09f12_01_adc_snap0_status_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_adc_snap0_status_addr_start   = hex2dec('01002100');
c09f12_01_adc_snap0_status_addr_end     = hex2dec('010021FF');

% c09f12_01/adc_snap0/tr_en_cnt
c09f12_01_adc_snap0_tr_en_cnt_type         = 'xps_sw_reg';
c09f12_01_adc_snap0_tr_en_cnt_param        = 'out';
c09f12_01_adc_snap0_tr_en_cnt_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_adc_snap0_tr_en_cnt_addr_start   = hex2dec('01002200');
c09f12_01_adc_snap0_tr_en_cnt_addr_end     = hex2dec('010022FF');

% c09f12_01/adc_snap0/trig_offset
c09f12_01_adc_snap0_trig_offset_type         = 'xps_sw_reg';
c09f12_01_adc_snap0_trig_offset_param        = 'in';
c09f12_01_adc_snap0_trig_offset_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_adc_snap0_trig_offset_addr_start   = hex2dec('01002300');
c09f12_01_adc_snap0_trig_offset_addr_end     = hex2dec('010023FF');

% c09f12_01/adc_snap0/val
c09f12_01_adc_snap0_val_type         = 'xps_sw_reg';
c09f12_01_adc_snap0_val_param        = 'out';
c09f12_01_adc_snap0_val_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_adc_snap0_val_addr_start   = hex2dec('01002400');
c09f12_01_adc_snap0_val_addr_end     = hex2dec('010024FF');

% c09f12_01/adc_snap1/bram
c09f12_01_adc_snap1_bram_type         = 'xps_bram';
c09f12_01_adc_snap1_bram_param        = '1024';
c09f12_01_adc_snap1_bram_ip_name      = 'bram_if';
c09f12_01_adc_snap1_bram_addr_start   = hex2dec('01003000');
c09f12_01_adc_snap1_bram_addr_end     = hex2dec('01003FFF');

% c09f12_01/adc_snap1/ctrl
c09f12_01_adc_snap1_ctrl_type         = 'xps_sw_reg';
c09f12_01_adc_snap1_ctrl_param        = 'in';
c09f12_01_adc_snap1_ctrl_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_adc_snap1_ctrl_addr_start   = hex2dec('01004000');
c09f12_01_adc_snap1_ctrl_addr_end     = hex2dec('010040FF');

% c09f12_01/adc_snap1/status
c09f12_01_adc_snap1_status_type         = 'xps_sw_reg';
c09f12_01_adc_snap1_status_param        = 'out';
c09f12_01_adc_snap1_status_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_adc_snap1_status_addr_start   = hex2dec('01004100');
c09f12_01_adc_snap1_status_addr_end     = hex2dec('010041FF');

% c09f12_01/adc_snap1/tr_en_cnt
c09f12_01_adc_snap1_tr_en_cnt_type         = 'xps_sw_reg';
c09f12_01_adc_snap1_tr_en_cnt_param        = 'out';
c09f12_01_adc_snap1_tr_en_cnt_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_adc_snap1_tr_en_cnt_addr_start   = hex2dec('01004200');
c09f12_01_adc_snap1_tr_en_cnt_addr_end     = hex2dec('010042FF');

% c09f12_01/adc_snap1/trig_offset
c09f12_01_adc_snap1_trig_offset_type         = 'xps_sw_reg';
c09f12_01_adc_snap1_trig_offset_param        = 'in';
c09f12_01_adc_snap1_trig_offset_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_adc_snap1_trig_offset_addr_start   = hex2dec('01004300');
c09f12_01_adc_snap1_trig_offset_addr_end     = hex2dec('010043FF');

% c09f12_01/adc_snap1/val
c09f12_01_adc_snap1_val_type         = 'xps_sw_reg';
c09f12_01_adc_snap1_val_param        = 'out';
c09f12_01_adc_snap1_val_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_adc_snap1_val_addr_start   = hex2dec('01004400');
c09f12_01_adc_snap1_val_addr_end     = hex2dec('010044FF');

% c09f12_01/adc_sum_sq0
c09f12_01_adc_sum_sq0_type         = 'xps_sw_reg';
c09f12_01_adc_sum_sq0_param        = 'out';
c09f12_01_adc_sum_sq0_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_adc_sum_sq0_addr_start   = hex2dec('01004500');
c09f12_01_adc_sum_sq0_addr_end     = hex2dec('010045FF');

% c09f12_01/adc_sum_sq1
c09f12_01_adc_sum_sq1_type         = 'xps_sw_reg';
c09f12_01_adc_sum_sq1_param        = 'out';
c09f12_01_adc_sum_sq1_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_adc_sum_sq1_addr_start   = hex2dec('01004600');
c09f12_01_adc_sum_sq1_addr_end     = hex2dec('010046FF');

% c09f12_01/board_id
c09f12_01_board_id_type         = 'xps_sw_reg';
c09f12_01_board_id_param        = 'in';
c09f12_01_board_id_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_board_id_addr_start   = hex2dec('01004700');
c09f12_01_board_id_addr_end     = hex2dec('010047FF');

% c09f12_01/clk_frequency
c09f12_01_clk_frequency_type         = 'xps_sw_reg';
c09f12_01_clk_frequency_param        = 'out';
c09f12_01_clk_frequency_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_clk_frequency_addr_start   = hex2dec('01004800');
c09f12_01_clk_frequency_addr_end     = hex2dec('010048FF');

% c09f12_01/coarse_ctrl
c09f12_01_coarse_ctrl_type         = 'xps_sw_reg';
c09f12_01_coarse_ctrl_param        = 'in';
c09f12_01_coarse_ctrl_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_coarse_ctrl_addr_start   = hex2dec('01004900');
c09f12_01_coarse_ctrl_addr_end     = hex2dec('010049FF');

% c09f12_01/coarse_delay0
c09f12_01_coarse_delay0_type         = 'xps_sw_reg';
c09f12_01_coarse_delay0_param        = 'in';
c09f12_01_coarse_delay0_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_coarse_delay0_addr_start   = hex2dec('01004A00');
c09f12_01_coarse_delay0_addr_end     = hex2dec('01004AFF');

% c09f12_01/coarse_delay1
c09f12_01_coarse_delay1_type         = 'xps_sw_reg';
c09f12_01_coarse_delay1_param        = 'in';
c09f12_01_coarse_delay1_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_coarse_delay1_addr_start   = hex2dec('01004B00');
c09f12_01_coarse_delay1_addr_end     = hex2dec('01004BFF');

% c09f12_01/control
c09f12_01_control_type         = 'xps_sw_reg';
c09f12_01_control_param        = 'in';
c09f12_01_control_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_control_addr_start   = hex2dec('01080000');
c09f12_01_control_addr_end     = hex2dec('010800FF');

% c09f12_01/delay_tr_status0
c09f12_01_delay_tr_status0_type         = 'xps_sw_reg';
c09f12_01_delay_tr_status0_param        = 'out';
c09f12_01_delay_tr_status0_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_delay_tr_status0_addr_start   = hex2dec('01080100');
c09f12_01_delay_tr_status0_addr_end     = hex2dec('010801FF');

% c09f12_01/delay_tr_status1
c09f12_01_delay_tr_status1_type         = 'xps_sw_reg';
c09f12_01_delay_tr_status1_param        = 'out';
c09f12_01_delay_tr_status1_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_delay_tr_status1_addr_start   = hex2dec('01080200');
c09f12_01_delay_tr_status1_addr_end     = hex2dec('010802FF');

% c09f12_01/eq0
c09f12_01_eq0_type         = 'xps_bram';
c09f12_01_eq0_param        = '4096';
c09f12_01_eq0_ip_name      = 'bram_if';
c09f12_01_eq0_addr_start   = hex2dec('01084000');
c09f12_01_eq0_addr_end     = hex2dec('01087FFF');

% c09f12_01/eq1
c09f12_01_eq1_type         = 'xps_bram';
c09f12_01_eq1_param        = '4096';
c09f12_01_eq1_ip_name      = 'bram_if';
c09f12_01_eq1_addr_start   = hex2dec('01088000');
c09f12_01_eq1_addr_end     = hex2dec('0108BFFF');

% c09f12_01/fine_ctrl
c09f12_01_fine_ctrl_type         = 'xps_sw_reg';
c09f12_01_fine_ctrl_param        = 'in';
c09f12_01_fine_ctrl_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_fine_ctrl_addr_start   = hex2dec('0108C000');
c09f12_01_fine_ctrl_addr_end     = hex2dec('0108C0FF');

% c09f12_01/fstatus0
c09f12_01_fstatus0_type         = 'xps_sw_reg';
c09f12_01_fstatus0_param        = 'out';
c09f12_01_fstatus0_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_fstatus0_addr_start   = hex2dec('0108C100');
c09f12_01_fstatus0_addr_end     = hex2dec('0108C1FF');

% c09f12_01/fstatus1
c09f12_01_fstatus1_type         = 'xps_sw_reg';
c09f12_01_fstatus1_param        = 'out';
c09f12_01_fstatus1_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_fstatus1_addr_start   = hex2dec('0108C200');
c09f12_01_fstatus1_addr_end     = hex2dec('0108C2FF');

% c09f12_01/gbe0
c09f12_01_gbe0_type         = 'xps_tengbe_v2';
c09f12_01_gbe0_param        = '';
c09f12_01_gbe0_ip_name      = 'kat_ten_gb_eth';
c09f12_01_gbe0_addr_start   = hex2dec('01090000');
c09f12_01_gbe0_addr_end     = hex2dec('01093FFF');

% c09f12_01/gbe_ip0
c09f12_01_gbe_ip0_type         = 'xps_sw_reg';
c09f12_01_gbe_ip0_param        = 'in';
c09f12_01_gbe_ip0_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_gbe_ip0_addr_start   = hex2dec('01094000');
c09f12_01_gbe_ip0_addr_end     = hex2dec('010940FF');

% c09f12_01/gbe_port
c09f12_01_gbe_port_type         = 'xps_sw_reg';
c09f12_01_gbe_port_param        = 'in';
c09f12_01_gbe_port_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_gbe_port_addr_start   = hex2dec('01094100');
c09f12_01_gbe_port_addr_end     = hex2dec('010941FF');

% c09f12_01/gbe_tx_cnt0
c09f12_01_gbe_tx_cnt0_type         = 'xps_sw_reg';
c09f12_01_gbe_tx_cnt0_param        = 'out';
c09f12_01_gbe_tx_cnt0_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_gbe_tx_cnt0_addr_start   = hex2dec('01094200');
c09f12_01_gbe_tx_cnt0_addr_end     = hex2dec('010942FF');

% c09f12_01/gbe_tx_err_cnt0
c09f12_01_gbe_tx_err_cnt0_type         = 'xps_sw_reg';
c09f12_01_gbe_tx_err_cnt0_param        = 'out';
c09f12_01_gbe_tx_err_cnt0_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_gbe_tx_err_cnt0_addr_start   = hex2dec('01094300');
c09f12_01_gbe_tx_err_cnt0_addr_end     = hex2dec('010943FF');

% c09f12_01/katadc0
c09f12_01_katadc0_type         = 'xps_katadc';
c09f12_01_katadc0_param        = 'adc = adc0 / interleave = off';
c09f12_01_katadc0_ip_name      = 'kat_adc_interface';
c09f12_01_katadc0_addr_start   = hex2dec('00040000');
c09f12_01_katadc0_addr_end     = hex2dec('000407ff');

% c09f12_01/ld_time_lsw0
c09f12_01_ld_time_lsw0_type         = 'xps_sw_reg';
c09f12_01_ld_time_lsw0_param        = 'in';
c09f12_01_ld_time_lsw0_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_ld_time_lsw0_addr_start   = hex2dec('01094400');
c09f12_01_ld_time_lsw0_addr_end     = hex2dec('010944FF');

% c09f12_01/ld_time_lsw1
c09f12_01_ld_time_lsw1_type         = 'xps_sw_reg';
c09f12_01_ld_time_lsw1_param        = 'in';
c09f12_01_ld_time_lsw1_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_ld_time_lsw1_addr_start   = hex2dec('01094500');
c09f12_01_ld_time_lsw1_addr_end     = hex2dec('010945FF');

% c09f12_01/ld_time_msw0
c09f12_01_ld_time_msw0_type         = 'xps_sw_reg';
c09f12_01_ld_time_msw0_param        = 'in';
c09f12_01_ld_time_msw0_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_ld_time_msw0_addr_start   = hex2dec('01094600');
c09f12_01_ld_time_msw0_addr_end     = hex2dec('010946FF');

% c09f12_01/ld_time_msw1
c09f12_01_ld_time_msw1_type         = 'xps_sw_reg';
c09f12_01_ld_time_msw1_param        = 'in';
c09f12_01_ld_time_msw1_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_ld_time_msw1_addr_start   = hex2dec('01094700');
c09f12_01_ld_time_msw1_addr_end     = hex2dec('010947FF');

% c09f12_01/leds/roach_gpioa0
c09f12_01_leds_roach_gpioa0_type         = 'xps_gpio';
c09f12_01_leds_roach_gpioa0_param        = '';
c09f12_01_leds_roach_gpioa0_ip_name      = 'gpio_simulink2ext';

% c09f12_01/leds/roach_gpioa1
c09f12_01_leds_roach_gpioa1_type         = 'xps_gpio';
c09f12_01_leds_roach_gpioa1_param        = '';
c09f12_01_leds_roach_gpioa1_ip_name      = 'gpio_simulink2ext';

% c09f12_01/leds/roach_gpioa2
c09f12_01_leds_roach_gpioa2_type         = 'xps_gpio';
c09f12_01_leds_roach_gpioa2_param        = '';
c09f12_01_leds_roach_gpioa2_ip_name      = 'gpio_simulink2ext';

% c09f12_01/leds/roach_gpioa3
c09f12_01_leds_roach_gpioa3_type         = 'xps_gpio';
c09f12_01_leds_roach_gpioa3_param        = '';
c09f12_01_leds_roach_gpioa3_ip_name      = 'gpio_simulink2ext';

% c09f12_01/leds/roach_gpioa4
c09f12_01_leds_roach_gpioa4_type         = 'xps_gpio';
c09f12_01_leds_roach_gpioa4_param        = '';
c09f12_01_leds_roach_gpioa4_ip_name      = 'gpio_simulink2ext';

% c09f12_01/leds/roach_gpioa5
c09f12_01_leds_roach_gpioa5_type         = 'xps_gpio';
c09f12_01_leds_roach_gpioa5_param        = '';
c09f12_01_leds_roach_gpioa5_ip_name      = 'gpio_simulink2ext';

% c09f12_01/leds/roach_gpioa6
c09f12_01_leds_roach_gpioa6_type         = 'xps_gpio';
c09f12_01_leds_roach_gpioa6_param        = '';
c09f12_01_leds_roach_gpioa6_ip_name      = 'gpio_simulink2ext';

% c09f12_01/leds/roach_gpioa7
c09f12_01_leds_roach_gpioa7_type         = 'xps_gpio';
c09f12_01_leds_roach_gpioa7_param        = '';
c09f12_01_leds_roach_gpioa7_ip_name      = 'gpio_simulink2ext';

% c09f12_01/leds/roach_gpioa_oe
c09f12_01_leds_roach_gpioa_oe_type         = 'xps_gpio';
c09f12_01_leds_roach_gpioa_oe_param        = '';
c09f12_01_leds_roach_gpioa_oe_ip_name      = 'gpio_simulink2ext';

% c09f12_01/leds/roach_led0
c09f12_01_leds_roach_led0_type         = 'xps_gpio';
c09f12_01_leds_roach_led0_param        = '';
c09f12_01_leds_roach_led0_ip_name      = 'gpio_simulink2ext';

% c09f12_01/leds/roach_led1
c09f12_01_leds_roach_led1_type         = 'xps_gpio';
c09f12_01_leds_roach_led1_param        = '';
c09f12_01_leds_roach_led1_ip_name      = 'gpio_simulink2ext';

% c09f12_01/leds/roach_led2
c09f12_01_leds_roach_led2_type         = 'xps_gpio';
c09f12_01_leds_roach_led2_param        = '';
c09f12_01_leds_roach_led2_ip_name      = 'gpio_simulink2ext';

% c09f12_01/leds/roach_led3
c09f12_01_leds_roach_led3_type         = 'xps_gpio';
c09f12_01_leds_roach_led3_param        = '';
c09f12_01_leds_roach_led3_ip_name      = 'gpio_simulink2ext';

% c09f12_01/mcount_lsw
c09f12_01_mcount_lsw_type         = 'xps_sw_reg';
c09f12_01_mcount_lsw_param        = 'out';
c09f12_01_mcount_lsw_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_mcount_lsw_addr_start   = hex2dec('01094800');
c09f12_01_mcount_lsw_addr_end     = hex2dec('010948FF');

% c09f12_01/mcount_msw
c09f12_01_mcount_msw_type         = 'xps_sw_reg';
c09f12_01_mcount_msw_param        = 'out';
c09f12_01_mcount_msw_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_mcount_msw_addr_start   = hex2dec('01094900');
c09f12_01_mcount_msw_addr_end     = hex2dec('010949FF');

% c09f12_01/pps_count
c09f12_01_pps_count_type         = 'xps_sw_reg';
c09f12_01_pps_count_param        = 'out';
c09f12_01_pps_count_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_pps_count_addr_start   = hex2dec('01094A00');
c09f12_01_pps_count_addr_end     = hex2dec('01094AFF');

% c09f12_01/qdr_ct/qdr
c09f12_01_qdr_ct_qdr_type         = 'xps_qdr';
c09f12_01_qdr_ct_qdr_param        = '';
c09f12_01_qdr_ct_qdr_addr_start   = hex2dec('0200_0000');
c09f12_01_qdr_ct_qdr_addr_end     = hex2dec('027F_FFFF');

% c09f12_01/rcs/app
c09f12_01_rcs_app_type         = 'xps_sw_reg';
c09f12_01_rcs_app_param        = 'out';
c09f12_01_rcs_app_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_rcs_app_addr_start   = hex2dec('01094B00');
c09f12_01_rcs_app_addr_end     = hex2dec('01094BFF');

% c09f12_01/rcs/lib
c09f12_01_rcs_lib_type         = 'xps_sw_reg';
c09f12_01_rcs_lib_param        = 'out';
c09f12_01_rcs_lib_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_rcs_lib_addr_start   = hex2dec('01094C00');
c09f12_01_rcs_lib_addr_end     = hex2dec('01094CFF');

% c09f12_01/rcs/user
c09f12_01_rcs_user_type         = 'xps_sw_reg';
c09f12_01_rcs_user_param        = 'out';
c09f12_01_rcs_user_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_rcs_user_addr_start   = hex2dec('01094D00');
c09f12_01_rcs_user_addr_end     = hex2dec('01094DFF');

% c09f12_01/snap_debug/addr
c09f12_01_snap_debug_addr_type         = 'xps_sw_reg';
c09f12_01_snap_debug_addr_param        = 'out';
c09f12_01_snap_debug_addr_ip_name      = 'opb_register_simulink2ppc';
c09f12_01_snap_debug_addr_addr_start   = hex2dec('01094E00');
c09f12_01_snap_debug_addr_addr_end     = hex2dec('01094EFF');

% c09f12_01/snap_debug/bram
c09f12_01_snap_debug_bram_type         = 'xps_bram';
c09f12_01_snap_debug_bram_param        = '2048';
c09f12_01_snap_debug_bram_ip_name      = 'bram_if';
c09f12_01_snap_debug_bram_addr_start   = hex2dec('01096000');
c09f12_01_snap_debug_bram_addr_end     = hex2dec('01097FFF');

% c09f12_01/snap_debug/ctrl
c09f12_01_snap_debug_ctrl_type         = 'xps_sw_reg';
c09f12_01_snap_debug_ctrl_param        = 'in';
c09f12_01_snap_debug_ctrl_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_snap_debug_ctrl_addr_start   = hex2dec('01098000');
c09f12_01_snap_debug_ctrl_addr_end     = hex2dec('010980FF');

% c09f12_01/trig_level
c09f12_01_trig_level_type         = 'xps_sw_reg';
c09f12_01_trig_level_param        = 'in';
c09f12_01_trig_level_ip_name      = 'opb_register_ppc2simulink';
c09f12_01_trig_level_addr_start   = hex2dec('01098100');
c09f12_01_trig_level_addr_end     = hex2dec('010981FF');

% OPB to OPB bridge added at 0x1080000
OPB_to_OPB_bridge_added_at_0x1080000_type         = 'xps_opb2opb';
OPB_to_OPB_bridge_added_at_0x1080000_param        = '';

