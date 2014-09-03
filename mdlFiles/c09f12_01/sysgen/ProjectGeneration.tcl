#
# Created by System Generator     Fri Aug  8 17:27:32 2014
#
# Note: This file is produced automatically, and will be overwritten the next
# time you press "Generate" in System Generator.
#

namespace eval ::xilinx::dsptool::iseproject::param {
    set SynthStrategyName {XST Defaults*}
    set ImplStrategyName {ISE Defaults*}
    set Compilation {NGC Netlist}
    set Project {c09f12_01_cw}
    set DSPFamily {Virtex5}
    set DSPDevice {xc5vsx95t}
    set DSPPackage {ff1136}
    set DSPSpeed {-1}
    set HDLLanguage {vhdl}
    set SynthesisTool {XST}
    set Simulator {Modelsim-SE}
    set ReadCores {False}
    set MapEffortLevel {High}
    set ParEffortLevel {High}
    set Frequency {200}
    set CreateInterfaceDocument {off}
    set NewXSTParser {0}
	if { [ string equal $Compilation {IP Packager} ] == 1 } {
		set PostProjectCreationProc {dsp_package_for_vivado_ip_integrator}
		set IP_Library_Text {SysGen}
		set IP_Vendor_Text {Xilinx}
		set IP_Version_Text {1.0}
		set IP_Categories_Text {System Generator for DSP}
		set IP_Common_Repos {0}
		set IP_Dir {}
		set IP_LifeCycle_Menu {1}
		set IP_Description    {}
		
	}
    set ProjectFiles {
        {{c09f12_01_cw.vhd} -view All}
        {{c09f12_01.vhd} -view All}
        {{c09f12_01_cw.ucf}}
        {{c09f12_01_cw.xdc}}
        {{bmg_72_7923a80e2a3186d3.mif}}
        {{bmg_72_804e79c102c84f5c.mif}}
        {{bmg_72_8ed993a9a42f84a8.mif}}
        {{bmg_72_deac774267b579f6.mif}}
        {{bmg_72_4f929f931e999067.mif}}
        {{bmg_72_4394a065975be75e.mif}}
        {{dmg_72_8cacf5ca230175f7.mif}}
        {{bmg_72_b3ad50e1afdb9e3d.mif}}
        {{dmg_72_8ff5c16d3b09b3bb.mif}}
        {{bmg_72_f27fe95e91d868c0.mif}}
        {{bmg_72_b673a6c277a0b565.mif}}
        {{bmg_72_321d886e2c47e239.mif}}
        {{bmg_72_bf7d8227d376109b.mif}}
        {{bmg_72_76e1be4e7480a75f.mif}}
        {{bmg_72_47e00fa602868a13.mif}}
        {{bmg_72_59f0d912b26aa159.mif}}
        {{bmg_72_b50899b30d5ca737.mif}}
        {{bmg_72_05b952b0e97b2a0d.mif}}
        {{bmg_72_35957677be9347c5.mif}}
        {{bmg_72_def2631b070914b0.mif}}
        {{bmg_72_48d0f511ba241493.mif}}
        {{bmg_72_a613d001e124acbe.mif}}
        {{bmg_72_b1697c6003ecdb6f.mif}}
        {{bmg_72_043bb11b7d009cca.mif}}
        {{dmg_72_c09662d4202cd49a.mif}}
        {{bmg_72_82d7e698d6cd5771.mif}}
        {{bmg_72_ddcdd9bb5f78a2a9.mif}}
        {{bmg_72_a6ba22940df932c0.mif}}
        {{bmg_72_37c9a3ecdc0c1393.mif}}
        {{bmg_72_ba30712f7b147c00.mif}}
        {{bmg_72_5eb14d6795836fe0.mif}}
        {{bmg_72_3bc6d5a32af9b138.mif}}
        {{bmg_72_763f056d1756d515.mif}}
        {{bmg_72_dc97d51467d52108.mif}}
        {{bmg_72_f55ad1fbb330c587.mif}}
        {{bmg_72_22ecfdf9c708a18d.mif}}
        {{dmg_72_9ddb0dccfe86828e.mif}}
        {{dmg_72_31a1909e3929c7f7.mif}}
        {{bmg_72_7884e23b5c653602.mif}}
        {{bmg_72_1853928182002eb1.mif}}
        {{bmg_72_3de7891ec729adb4.mif}}
        {{bmg_72_031b3366e458494d.mif}}
        {{bmg_72_765e7ee20c0385ac.mif}}
        {{dmg_72_60b1d930b1392bee.mif}}
        {{bmg_72_04e0d9cde0f49a3d.mif}}
        {{/data/casper/mlib_devel_cbass/c09f12_01.slx}}
    }
    set TopLevelModule {c09f12_01_cw}
    set SynthesisConstraintsFile {c09f12_01_cw.xcf}
    set ImplementationStopView {Structural}
    set ProjectGenerator {SysgenDSP}
}
    source SgIseProject.tcl
    ::xilinx::dsptool::iseproject::create
