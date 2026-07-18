; +---------------------------------+
; | Vulgus Disassembly v0.09        |
; | - by tcdev (msmcdoug@gmail.com) |
; +---------------------------------+
;
; This disassembly is about 95% complete
; Areas not complete comprise:
; - alien object data (mainly movement data)
; - map generation (packed data structures)
;
; this matches "vulgusa" rom
;
; Processor       : z80 []
; converted back to MAME-style disassembly by jotd

;	map(0x0000, 0x9fff).rom();
;	map(0xc000, 0xc000).portr("SYSTEM");
;	map(0xc001, 0xc001).portr("P1");
;	map(0xc002, 0xc002).portr("P2");
;	map(0xc003, 0xc003).portr("DSW1");
;	map(0xc004, 0xc004).portr("DSW2");
;	map(0xc800, 0xc800).w("soundlatch", FUNC(generic_latch_8_device::write));
;	map(0xc801, 0xc801).nopw(); // ?
;	map(0xc802, 0xc803).ram().share(m_scroll_low);  Y then X
;	map(0xc804, 0xc804).w(FUNC(vulgus_state::c804_w));
;	map(0xc805, 0xc805).w(FUNC(vulgus_state::palette_bank_w));
;	map(0xc902, 0xc903).ram().share(m_scroll_high);  Y then X
;	map(0xcc00, 0xcc7f).ram().share(m_spriteram);
;	map(0xd000, 0xd7ff).ram().w(FUNC(vulgus_state::fgvideoram_w)).share(m_fgvideoram);
;	map(0xd800, 0xdfff).ram().w(FUNC(vulgus_state::bgvideoram_w)).share(m_bgvideoram);
;	map(0xe000, 0xefff).ram();

;	PORT_BIT( 0x01, IP_ACTIVE_LOW, IPT_START1 )
;	PORT_BIT( 0x02, IP_ACTIVE_LOW, IPT_START2 )
;	PORT_BIT( 0x04, IP_ACTIVE_LOW, IPT_UNKNOWN )    // probably unused
;	PORT_BIT( 0x08, IP_ACTIVE_LOW, IPT_UNKNOWN )    // probably unused
;	PORT_BIT( 0x10, IP_ACTIVE_LOW, IPT_UNKNOWN )    // probably unused
;	PORT_BIT( 0x20, IP_ACTIVE_LOW, IPT_UNKNOWN )    // probably unused
;	PORT_BIT( 0x40, IP_ACTIVE_LOW, IPT_COIN2 )
;	PORT_BIT( 0x80, IP_ACTIVE_LOW, IPT_COIN1 )
;
;	PORT_START("P1")
;	PORT_BIT( 0x01, IP_ACTIVE_LOW, IPT_JOYSTICK_RIGHT ) PORT_8WAY
;	PORT_BIT( 0x02, IP_ACTIVE_LOW, IPT_JOYSTICK_LEFT ) PORT_8WAY
;	PORT_BIT( 0x04, IP_ACTIVE_LOW, IPT_JOYSTICK_DOWN ) PORT_8WAY
;	PORT_BIT( 0x08, IP_ACTIVE_LOW, IPT_JOYSTICK_UP ) PORT_8WAY
;	PORT_BIT( 0x10, IP_ACTIVE_LOW, IPT_BUTTON1 )
;	PORT_BIT( 0x20, IP_ACTIVE_LOW, IPT_BUTTON2 )
;	PORT_BIT( 0x40, IP_ACTIVE_LOW, IPT_UNKNOWN )
;	PORT_BIT( 0x80, IP_ACTIVE_LOW, IPT_UNKNOWN )
;
;	PORT_START("P2")
;	PORT_BIT( 0x01, IP_ACTIVE_LOW, IPT_JOYSTICK_RIGHT ) PORT_8WAY PORT_COCKTAIL
;	PORT_BIT( 0x02, IP_ACTIVE_LOW, IPT_JOYSTICK_LEFT ) PORT_8WAY PORT_COCKTAIL
;	PORT_BIT( 0x04, IP_ACTIVE_LOW, IPT_JOYSTICK_DOWN ) PORT_8WAY PORT_COCKTAIL
;	PORT_BIT( 0x08, IP_ACTIVE_LOW, IPT_JOYSTICK_UP ) PORT_8WAY PORT_COCKTAIL
;	PORT_BIT( 0x10, IP_ACTIVE_LOW, IPT_BUTTON1 ) PORT_COCKTAIL
;	PORT_BIT( 0x20, IP_ACTIVE_LOW, IPT_BUTTON2 ) PORT_COCKTAIL
;	PORT_BIT( 0x40, IP_ACTIVE_LOW, IPT_UNKNOWN )
;	PORT_BIT( 0x80, IP_ACTIVE_LOW, IPT_UNKNOWN )
;
;	PORT_START("DSW1")
;	PORT_DIPNAME( 0x03, 0x03, DEF_STR( Lives ) )        PORT_DIPLOCATION("SW1:8,7")
;	PORT_DIPSETTING(    0x01, "1" )
;	PORT_DIPSETTING(    0x02, "2" )
;	PORT_DIPSETTING(    0x03, "3" )
;	PORT_DIPSETTING(    0x00, "5" )
;	// Only the parent set seems to use/see the second coin slot even if set to Cocktail mode
;	PORT_DIPNAME( 0x1c, 0x1c, DEF_STR( Coin_B ) )       PORT_DIPLOCATION("SW1:6,5,4")
;	PORT_DIPSETTING(    0x10, DEF_STR( 5C_1C ) )
;	PORT_DIPSETTING(    0x08, DEF_STR( 4C_1C ) )
;	PORT_DIPSETTING(    0x18, DEF_STR( 3C_1C ) )
;	PORT_DIPSETTING(    0x04, DEF_STR( 2C_1C ) )
;	PORT_DIPSETTING(    0x1c, DEF_STR( 1C_1C ) )
;	PORT_DIPSETTING(    0x0c, DEF_STR( 1C_2C ) )
;	PORT_DIPSETTING(    0x14, DEF_STR( 1C_3C ) )
;	PORT_DIPSETTING(    0x00, "Invalid" ) // disables both coins
;	PORT_DIPNAME( 0xe0, 0xe0, DEF_STR( Coin_A ) )       PORT_DIPLOCATION("SW1:3,2,1")
;	PORT_DIPSETTING(    0x80, DEF_STR( 5C_1C ) )
;	PORT_DIPSETTING(    0x40, DEF_STR( 4C_1C ) )
;	PORT_DIPSETTING(    0xc0, DEF_STR( 3C_1C ) )
;	PORT_DIPSETTING(    0x20, DEF_STR( 2C_1C ) )
;	PORT_DIPSETTING(    0xe0, DEF_STR( 1C_1C ) )
;	PORT_DIPSETTING(    0x60, DEF_STR( 1C_2C ) )
;	PORT_DIPSETTING(    0xa0, DEF_STR( 1C_3C ) )
;	PORT_DIPSETTING(    0x00, DEF_STR( Free_Play ) )
;
;	PORT_START("DSW2")
;	PORT_DIPUNUSED_DIPLOC( 0x01, 0x01, "SW2:8" ) // Shown as "Unused" in the manual, are 7 & 8 undocumented Difficulty??
;	PORT_DIPUNUSED_DIPLOC( 0x02, 0x02, "SW2:7" ) // Shown as "Unused" in the manual, Code performs a read then (& 0x03)
;	PORT_DIPNAME( 0x04, 0x04, "Demo Music" )        PORT_DIPLOCATION("SW2:6")
;	PORT_DIPSETTING(    0x00, DEF_STR( Off ) )
;	PORT_DIPSETTING(    0x04, DEF_STR( On ) )
;	PORT_DIPNAME( 0x08, 0x08, DEF_STR( Demo_Sounds ) )  PORT_DIPLOCATION("SW2:5")
;	PORT_DIPSETTING(    0x00, DEF_STR( Off ) )
;	PORT_DIPSETTING(    0x08, DEF_STR( On ) )
;	PORT_DIPNAME( 0x70, 0x70, DEF_STR( Bonus_Life ) )   PORT_DIPLOCATION("SW2:4,3,2")
;	PORT_DIPSETTING(    0x30, "10000 50000" )
;	PORT_DIPSETTING(    0x50, "10000 60000" )
;	PORT_DIPSETTING(    0x10, "10000 70000" )
;	PORT_DIPSETTING(    0x70, "20000 60000" )
;	PORT_DIPSETTING(    0x60, "20000 70000" )
;	PORT_DIPSETTING(    0x20, "20000 80000" )
;	PORT_DIPSETTING(    0x40, "30000 70000" )
;	PORT_DIPSETTING(    0x00, DEF_STR( None ) )
;	PORT_DIPNAME( 0x80, 0x00, DEF_STR( Cabinet ) )      PORT_DIPLOCATION("SW2:1")
;	PORT_DIPSETTING(    0x00, DEF_STR( Upright ) )
;	PORT_DIPSETTING(    0x80, DEF_STR( Cocktail ) )
; ===========================================================================

dsw1_c003 = $c003
dsw2_c004 = $c004
flipscreen_c804  = $c804
port_1_c001 = $c001
port_2_c002 = $c002
palette_bank_w_c805 = $c805
scroll_high_c902 = $C902
system_c000 = $C000
bg_tiles_address_d800 = $d800
fg_tiles_address_d000 = $d000
fg_tiles_color_address_d400 = $d400
bg_tiles_color_address_dc00 = $dc00

; Segment type: Pure code

reset_0000:		; [global]
0000: F3          di
0001: 31 00 F0    ld      sp,$F000                     ; end of RAM
0004: C3 4A 00    jp      init_004a
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================


nullsub_1_0008:
0008: C9          ret
; End of function nullsub_1_0008

; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------

vblank_isr_0010:
0010: F3          di
0011: C3 B0 01    jp      vblank_isr_01b0
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================


hl_plus_equals_a_0018:                                               ; ...
0018: 85          add     a,l
0019: 6F          ld      l,a
001A: 30 01       jr      NC,locret_001d
001C: 24          inc     h

locret_001d:                                                      ; ...
001D: C9          ret
; End of function hl_plus_equals_a_0018

; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================


content_hl_plus_a_0020:                                              ; ...
0020: 85          add     a,l
0021: 6F          ld      l,a
0022: 30 01       jr      NC,loc_0025
0024: 24          inc     h

loc_0025:                                                         ; ...
0025: 7E          ld      a,(hl)
0026: C9          ret
; End of function content_hl_plus_a_0020

; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================


de_eq_contents_hl_plus_2a_0028:                                      ; ...
0028: 87          add     a,a
0029: DF          rst     hl_plus_equals_a_0018
002A: 5E          ld      e,(hl)
002B: 23          inc     hl
002C: 56          ld      d,(hl)
002D: 23          inc     hl
002E: C9          ret
; End of function de_eq_contents_hl_plus_2a_0028

; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================


jp_tbl_vector_0030:                                                  ; ...
0030: E1          pop     hl                              ; vector_tbl_addr
0031: EF          rst     de_eq_contents_hl_plus_2a_0028       ; calc_offset
0032: EB          ex      de,hl
0033: E9          jp      (hl)                            ; go
; End of function jp_tbl_vector_0030

; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================


add_fn_to_q_0038:                                                    ; ...
0038: 2A A0 ED    ld      hl,(ptr_q_tail_eda0)
003B: 72          ld      (hl),d                         ; save fn ordinal
003C: 2C          inc     l
003D: 73          ld      (hl),e                         ; save fn parameter
003E: 2C          inc     l
003F: 7D          ld      a,l
0040: FE 40       cp      $40 ; '@'                     ; end of buffer?
0042: 38 02       jr      C,loc_0046                       ; no,skip
0044: 2E 00       ld      l,0                           ; wrap

loc_0046:                                                         ; ...
0046: 22 A0 ED    ld      (ptr_q_tail_eda0),hl                ; update ptr
0049: C9          ret
; End of function add_fn_to_q_0038

; ---------------------------------------------------------------------------

init_004a:                                                           ; ...
004A: 21 00 E0    ld      hl,vblank_tick_e000
004D: 11 01 E0    ld      de,system_e001
0050: 36 00       ld      (hl),0
0052: 01 FF 0F    ld      bc,$FFF
0055: ED B0       ldir
0057: 21 00 D0    ld      hl,fgvideoram_code_d000
005A: 11 01 D0    ld      de,fgvideoram_code_d000+1
005D: 36 20       ld      (hl),$20 ; blank  ; [video_address]
005F: 01 FF 03    ld      bc,$3FF
0062: ED B0       ldir  ; [video_address]
0064: 21 00 D4    ld      hl,fgvideoram_color_d400
0067: 11 01 D4    ld      de,fgvideoram_color_d400+1
006A: 36 01       ld      (hl),1        ; attrib  ; [video_address]
006C: 01 FF 03    ld      bc,$3FF
006F: ED B0       ldir  ; [video_address]
0071: 21 6F 01    ld      hl,default_hi_score_tbl_016f	; data
0074: E5          push    hl
0075: 11 47 EE    ld      de,hi_score_ee47
0078: ED A0       ldi
007A: ED A0       ldi
007C: ED A0       ldi                                     ; initialise hi score
007E: E1          pop     hl
007F: 11 00 EE    ld      de,hiscore_tbl_ee00
0082: 01 41 00    ld      bc,$41 ; 'A'
0085: ED B0       ldir                                    ; initialise hi score table
0087: 21 00 ED    ld      hl,queue_buffer_ed00
008A: 22 A2 ED    ld      (ptr_q_head_eda2),hl
008D: 22 A0 ED    ld      (ptr_q_tail_eda0),hl
0090: 11 01 ED    ld      de,queue_buffer_ed00+1
0093: 36 FF       ld      (hl),$FF                     ; flag invalid
0095: 01 3F 00    ld      bc,63                         ; 64 bytes
0098: ED B0       ldir
009A: 21 80 ED    ld      hl,snd_buffer_ed80
009D: 22 A8 ED    ld      (snd_buffer_start_eda8),hl
00A0: 22 A6 ED    ld      (snd_buffer_end_eda6),hl
00A3: 11 81 ED    ld      de,snd_buffer_ed80+1
00A6: 36 FF       ld      (hl),$FF                     ; flag invalid
00A8: 01 1F 00    ld      bc,31                         ; 32 bytes
00AB: ED B0       ldir
00AD: CD A1 02    call    hide_all_sprites_02a1
00B0: CD A2 47    call    nullsub_2_47a2
00B3: CD 9D 47    call    snd_cmd_08_479d
00B6: 3E 00       ld      a,0
00B8: 32 07 E0    ld      (curr_controls_e007),a
00BB: 3E 0F       ld      a,$F
00BD: 32 83 EF    ld      (palette_bank_shadow_ef83),a
00C0: 3E 40       ld      a,$40 ; '@'
00C2: 32 42 E0    ld      (byte_e042),a
00C5: 32 43 E0    ld      (byte_e043),a
; read dipswitches
00C8: 3A 03 C0    ld      a,(dsw1_c003)		; [unchecked_address]
00CB: 2F          cpl
00CC: 47          ld      b,a                            ; save
00CD: 21 66 01    ld      hl,lives_tbl_0166
00D0: E6 03       and     3                              ; lives setting
00D2: E7          rst     content_hl_plus_a_0020
00D3: 32 1C E0    ld      (start_lives_e01c),a
00D6: 78          ld      a,b                            ; dsw1_c003
00D7: 0F          rrca
00D8: 0F          rrca
00D9: E6 07       and     7                              ; coinB
00DB: 21 56 01    ld      hl,coin_tbl_0156
00DE: 87          add     a,a
00DF: E7          rst     content_hl_plus_a_0020               ; coinB setting
00E0: 32 12 E0    ld      (coinb_coins_e012),a
00E3: 23          inc     hl
00E4: 7E          ld      a,(hl)
00E5: 32 14 E0    ld      (coinb_credits_e014),a
00E8: A7          and     a                               ; zero credits_e022?
00E9: 20 04       jr      NZ,loc_00ef                      ; no,skip
00EB: 3D          dec     a                               ; $FF
00EC: 32 10 E0    ld      (freeplay_e010),a                   ; flag freeplay_e010

loc_00ef:                                                         ; ...
00EF: 78          ld      a,b                            ; dsw1_c003
00F0: 07          rlca
00F1: 07          rlca
00F2: 07          rlca
00F3: E6 07       and     7                              ; coinA
00F5: 21 56 01    ld      hl,coin_tbl_0156
00F8: 87          add     a,a
00F9: E7          rst     content_hl_plus_a_0020

loc_00fa:
00FA: 32 11 E0    ld      (coina_coins_e011),a
00FD: 23          inc     hl
00FE: 7E          ld      a,(hl)
00FF: 32 13 E0    ld      (coina_credits_e013),a
0102: A7          and     a                               ; zero credits_e022?
0103: 20 04       jr      NZ,loc_0109                     ; no,skip
0105: 3D          dec     a
0106: 32 10 E0    ld      (freeplay_e010),a                   ; flag freeplay_e010

loc_0109:                                                        ; ...
0109: 3A 04 C0    ld      a,(dsw2_c004)	; [unchecked_address]
010C: 2F          cpl
010D: 47          ld      b,a                            ; save
010E: E6 03       and     3                              ; unknown
0110: 21 52 01    ld      hl,unknown_dsw_tbl_0152
0113: E7          rst     content_hl_plus_a_0020
0114: 32 17 E0    ld      (mystery_dsw_setting_e017),a
0117: 78          ld      a,b                            ; dsw2_c004
0118: 2F          cpl

loc_0119:                                                        ; demo music
0119: E6 04       and     4
011B: 32 18 E0    ld      (demo_music_e018),a
011E: 78          ld      a,b                            ; dsw2_c004
011F: 2F          cpl
0120: E6 08       and     8                              ; demo sounds
0122: 32 19 E0    ld      (demo_sounds_e019),a
0125: 78          ld      a,b                            ; dsw2_c004
0126: 2F          cpl
0127: E6 80       and     $80 ;                      ; cabinet_e01d
0129: 32 1D E0    ld      (cabinet_e01d),a                    ; $00 = cocktail
012C: 78          ld      a,b                            ; dsw2_c004
012D: 0F          rrca
012E: 0F          rrca
012F: 0F          rrca
0130: 0F          rrca
0131: E6 07       and     7                              ; bonus life
0133: 21 42 01    ld      hl,bonus_lives_tbl_0142
0136: 87          add     a,a
0137: E7          rst     content_hl_plus_a_0020
0138: 32 1A E0    ld      (bonus_life_1st_e01a),a
013B: 23          inc     hl
013C: 7E          ld      a,(hl)
013D: 32 1B E0    ld      (bonus_life_2nd_e01b),a
0140: 18 28       jr      init_cont_1_016a
; ---------------------------------------------------------------------------
;	.word 0x6020                              ; ...
;0142:                                                     ; 2000,6000
;	.word 0x7020                              ; 2000,7000
;	.word 0x6010                              ; 1000,6000
;	.word 0x7030                              ; 3000,7000
;	.word 0x5010                              ; 1000,5000
;	.word 0x8020                              ; 2000,8000
;	.word 0x7010                              ; 1000,7000
;	.word 0                                   ; None
;; coin A/B settings COIN,CREDIT
;	.word 0x101                               ; ...
;	.word 0x103
;	.word 0x301
;	.word 0x105
;	.word 0x201
;	.word 0x104
;	.word 0x102
;	.word 1
; ---------------------------------------------------------------------------

init_cont_1_016a:                                                    ; ...
016A: 00          nop
016B: FB          ei
016C: C3 B6 02    jp      main_loop_02b6
; ---------------------------------------------------------------------------
;at_t_0172:                   .ascii 'T.T       '                     ; 1st
;am_k_017f:                   .ascii 'M.K       '                     ; 2nd
;ay_m_018c:                   .ascii 'Y.M       '                     ; 3rd
;aa_f_0199:                   .ascii 'A.F       '                     ; 4th
;as_o_01a6:                   .ascii 'S.O       '                     ; 5th
; ---------------------------------------------------------------------------

vblank_isr_01b0:               ; [global]
01B0: F5          push    af
01B1: C5          push    bc
01B2: D5          push    de
01B3: E5          push    hl
01B4: D9          exx
01B5: 08          ex      af,af'
01B6: F5          push    af
01B7: C5          push    bc
01B8: D5          push    de
01B9: E5          push    hl
01BA: DD E5       push    ix
01BC: FD E5       push    iy
01BE: CD F6 01    call    vblank_sub_01f6
01C1: 21 01 D2    ld      hl,fgvideoram_code_d000+0x201
01C4: 06 0E       ld      b,$E
01C6: FD E1       pop     iy
01C8: DD E1       pop     ix
01CA: E1          pop     hl
01CB: D1          pop     de
01CC: C1          pop     bc
01CD: F1          pop     af
01CE: 08          ex      af,af'
01CF: D9          exx
01D0: E1          pop     hl
01D1: D1          pop     de
01D2: C1          pop     bc
01D3: F1          pop     af
01D4: FB          ei
01D5: C9          ret

; copies the pre-rendered line (column) from the
;   pre-render buffer to the bg RAM
;   - both code and colour areas are copied

; =============== S U B R O U T I N E =======================================


render_bg_line_01d6:                                                 ; ...
01D6: 3D          dec     a
01D7: 32 48 E0    ld      (bg_lines_to_render_e048),a         ; update
01DA: ED 5B 49 E0 ld      de,(bg_prerender_ptr_e049)
01DE: D5          push    de

loc_01df:
01DF: 21 50 E0    ld      hl,bg_prerender_buffer_e050
01E2: 01 20 00    ld      bc,$20 ; ' '                 ; 1 column
01E5: ED B0       ldir		; [video_address]
01E7: D9          exx
01E8: D1          pop     de
01E9: 21 00 04    ld      hl,$400
01EC: 19          add     hl,de                          ; ptr colour memory
01ED: E5          push    hl
01EE: D9          exx
01EF: D1          pop     de
01F0: 01 20 00    ld      bc,$20 ; ' '                 ; 1 column
01F3: ED B0       ldir		; [video_address]
01F5: C9          ret
; End of function render_bg_line_01d6


; =============== S U B R O U T I N E =======================================


vblank_sub_01f6:                                                     ; ...
01F6: 3A 48 E0    ld      a,(bg_lines_to_render_e048)
01F9: A7          and     a                               ; any lines to render?
01FA: C4 D6 01    call    NZ,render_bg_line_01d6              ; yes,render
01FD: 3A 07 E0    ld      a,(curr_controls_e007)
0200: 2F          cpl
0201: E6 01       and     1
0203: 0F          rrca                                    ; bit 7
0204: 47          ld      b,a                            ; save
0205: 3A 82 EF    ld      a,(flipscreen_shadow_ef82)
0208: E6 7F       and     $7F ; ''                     ; mask off old flip bit
020A: 80          add     a,b                            ; add new flip bit
020B: 32 82 EF    ld      (flipscreen_shadow_ef82),a
020E: CD 82 02    call    update_snd_graphics_hw_0282          ; latch,palette,flip,sprites
0211: 21 01 D2    ld      hl,fgvideoram_code_d000+0x201
0214: 06 0E       ld      b,$E
0216: 21 00 E0    ld      hl,vblank_tick_e000
0219: 34          inc     (hl)                            ; tick!
021A: CD 03 15    call    check_freeplay_1503
021D: 3A 00 C0    ld      a,(system_c000)                     ; coin,start [unchecked_address]
0220: 2F          cpl
0221: 32 01 E0    ld      (system_e001),a
0224: 3A 01 C0    ld      a,(port_1_c001)                         ; port_1_c001 controls [unchecked_address]
0227: 2F          cpl
0228: 32 02 E0    ld      (p1_e002),a
022B: 3A 02 C0    ld      a,(port_2_c002)                         ; port_2_c002 controls [unchecked_address]
022E: 2F          cpl
022F: 32 03 E0    ld      (p2_e003),a
0232: 11 02 E0    ld      de,p1_e002                         ; port_1_c001 controls
0235: 21 08 E0    ld      hl,curr_player_right_e008
0238: 3A 07 E0    ld      a,(curr_controls_e007)
023B: E6 01       and     1                              ; p1_e002?
023D: 28 01       jr      Z,loc_0240                      ; yes,skip
023F: 1C          inc     e                               ; ptr port_2_c002 controls

loc_0240:                                                        ; ...
0240: 1A          ld      a,(de)                         ; get curr player controls
0241: 0F          rrca                                    ; right
0242: CB 16       rl      (hl)
0244: 2C          inc     l
0245: 0F          rrca                                    ; left
0246: CB 16       rl      (hl)
0248: 2C          inc     l
0249: 0F          rrca                                    ; down

loc_024a:
024A: CB 16       rl      (hl)
024C: 2C          inc     l
024D: 0F          rrca                                    ; up
024E: CB 16       rl      (hl)
0250: 2C          inc     l
0251: 0F          rrca                                    ; button 1
0252: CB 16       rl      (hl)
0254: 2C          inc     l
0255: 0F          rrca                                    ; button 2
0256: CB 16       rl      (hl)
0258: CD BE 47    call    write_next_snd_cmd_47be
025B: 2A 46 E0    ld      hl,(scroll_plus1_shadow_e046)
025E: 7D          ld      a,l
025F: 32 03 C8    ld      (scroll_low_c802+1),a
0262: 7C          ld      a,h
0263: E6 01       and     1
0265: 32 03 C9    ld      (scroll_high_c902+1),a
0268: 2A 44 E0    ld      hl,(scroll_shadow_e044)
026B: 7D          ld      a,l
026C: 32 02 C8    ld      (scroll_low_c802),a
026F: 7C          ld      a,h
0270: E6 01       and     1
0272: 32 02 C9    ld      (scroll_high_c902),a
0275: 3A 05 E0    ld      a,(vbl_lvl_0_fn_e005)
0278: F7          rst    $30		; [jump_to_jump_table] [nb_entries=4]
; End of function vblank_sub_01f6

; ---------------------------------------------------------------------------
	.word vbl_0_fn_0__attract_text_0921            ; calls another table
	.word vbl_0_fn_1__attract_mode_0935            ; calls another table
	.word vbl_0_fn_2__check_start_098f             ; calls another table
	.word vbl_0_fn_3__handle_game_1057             ; calls another table
; ---------------------------------------------------------------------------
0281: C9          ret

; =============== S U B R O U T I N E =======================================


update_snd_graphics_hw_0282:                                         ; ...
0282: 21 80 EF    ld      hl,soundlatch_shadow_ef80
0285: 11 00 C8    ld      de,soundlatch_c800
0288: ED A0       ldi
028A: ED A0       ldi
028C: 7E          ld      a,(hl)
028D: 32 04 C8    ld      (flipscreen_c804),a
0290: 2C          inc     l
0291: 7E          ld      a,(hl)
0292: 32 05 C8    ld      (palette_bank_w_c805),a
0295: 21 00 EF    ld      hl,spriteram_shadow_ef00
0298: 11 00 CC    ld      de,spriteram_cc00
029B: 01 60 00    ld      bc,96                         ; 24 sprites
029E: ED B0       ldir
02A0: C9          ret
; End of function update_snd_graphics_hw_0282


; =============== S U B R O U T I N E =======================================


hide_all_sprites_02a1:                                               ; ...
02A1: DD 21 00 EF ld      ix,spriteram_shadow_ef00
02A5: 06 18       ld      b,24                          ; 24 sprites
02A7: 11 04 00    ld      de,4                          ; bytes/sprite
02AA: AF          xor     a

loc_02ab:                                                        ; ...
02AB: DD 77 02    ld      (ix+$02),a                        ; y=0
02AE: DD 77 01    ld      (ix+$01),a                        ; colour=0
02B1: DD 19       add     ix,de                          ; next sprite
02B3: 10 F6       djnz    loc_02ab
02B5: C9          ret
; End of function hide_all_sprites_02a1

; ---------------------------------------------------------------------------

main_loop_02b6:                                                      ; ...
02B6: FB          ei
02B7: CD BD 02    call    process_q_02bd
02BA: C3 B6 02    jp      main_loop_02b6

; processes the next function in the queue

; =============== S U B R O U T I N E =======================================


process_q_02bd:                                                      ; ...

; FUNCTION CHUNK AT ROM:365A SIZE 0000004B BYTES
; FUNCTION CHUNK AT ROM:36E2 SIZE 0000002A BYTES

02BD: 2A A2 ED    ld      hl,(ptr_q_head_eda2)
02C0: 7E          ld      a,(hl)                         ; q_entry
02C1: 3C          inc     a                               ; valid?
02C2: C8          ret     Z                               ; no,return
02C3: 3D          dec     a                               ; restore entry
02C4: 57          ld      d,a                            ; save fn ordinal
02C5: 36 FF       ld      (hl),$FF                     ; flag invalid
02C7: 2C          inc     l                               ; inc q ptr
02C8: 5E          ld      e,(hl)                         ; get fn param
02C9: 36 FF       ld      (hl),$FF                     ; flag invalid
02CB: 2C          inc     l                               ; inc q ptr
02CC: 7D          ld      a,l
02CD: FE 40       cp      $40 ; '@'                     ; end of buffer?
02CF: 38 02       jr      C,loc_02d3                      ; no,skip
02D1: 2E 00       ld      l,0                           ; wrap

loc_02d3:                                                        ; ...
02D3: 22 A2 ED    ld      (ptr_q_head_eda2),hl                ; update ptr
02D6: 7B          ld      a,e                            ; fn param
02D7: 32 A4 ED    ld      (q_param_eda4),a                    ; save
02DA: 7A          ld      a,d                            ; fn ordinal
02DB: F7          rst    $30		  ; [jump_to_jump_table] [nb_entries=16]
; ---------------------------------------------------------------------------
	.word main_fn_0__print_string_param_03a4
	.word main_fn_1__wipe_string_param_03af
	.word main_fn_2__print_curr_score_03ba
	.word main_fn_3__print_hi_score_03c5
	.word main_fn_4__print_hi_score_tbl_03c8
	.word main_fn_56__print_credits_043e
	.word main_fn_56__print_credits_043e
	.word main_fn_7__cls_044f                      ; main_fn_7(char,long,short)
	.word main_fn_8__add_to_score_update_hi_068e
	.word main_fn_9__print_lives_ships_035a
	.word main_fn_1011__scroll_left_18_rows_077b
	.word main_fn_1011__scroll_left_18_rows_077b
	.word main_fn_12__show_or_wipe_fg_title_0784
	.word main_fn_13__show_bombs_08fa
	.word main_fn_14__print_bonus_life_scores_0336
	.word main_fn_15__show_bg_attract_mode_title_02fc
; ---------------------------------------------------------------------------

main_fn_15__show_bg_attract_mode_title_02fc:                         ; ...
02FC: 21 D8 08    ld      hl,bg_title_colour_08d8
02FF: 4E          ld      c,(hl)                         ; colour
0300: 23          inc     hl                              ; inc ptr
0301: EB          ex      de,hl
0302: 21 44 D9    ld      hl,bgvideoram_code_d800+0x144
0305: CD 15 03    call    show_attract_mode_title_row_0315
0308: 21 24 D9    ld      hl,bgvideoram_code_d800+0x124
030B: CD 15 03    call    show_attract_mode_title_row_0315
030E: 21 04 D9    ld      hl,bgvideoram_code_d800+0x104
0311: CD 15 03    call    show_attract_mode_title_row_0315
0314: C9          ret
; End of function process_q_02bd


; =============== S U B R O U T I N E =======================================


show_attract_mode_title_row_0315:                                    ; ...
0315: 06 0B       ld      b,11                          ; 11 chars to copy

loc_0317:                                                        ; ...
0317: 1A          ld      a,(de)                         ; get char
0318: 13          inc     de                              ; next char
0319: C6 E0       add     a,$E0 ; '�'
031B: 77          ld      (hl),a                         ; code  [unchecked_address]
031C: CB D4       set     2,h                            ; ptr colour
031E: 71          ld      (hl),c                         ; colour  [video_address]
031F: CB 94       res     2,h                            ; ptr code
0321: 23          inc     hl                              ; next video address
0322: 10 F3       djnz    loc_0317                         ; loop
0324: 21 E0 01    ld      hl,$1E0
0327: 22 46 E0    ld      (scroll_plus1_shadow_e046),hl
032A: 21 18 00    ld      hl,$18
032D: 22 44 E0    ld      (scroll_shadow_e044),hl
0330: 3E 03       ld      a,3                           ; palette bank
0332: 32 83 EF    ld      (palette_bank_shadow_ef83),a
0335: C9          ret
; End of function show_attract_mode_title_row_0315

; ---------------------------------------------------------------------------

main_fn_14__print_bonus_life_scores_0336:                            ; ...
0336: 3A 1A E0    ld      a,(bonus_life_1st_e01a)
0339: A7          and     a
033A: C8          ret     Z                               ; none,return
033B: 21 41 05    ld      hl,str1stbonus20000_1_0541
033E: CD 8F 41    call    print_string_418f
0341: 3A 1A E0    ld      a,(bonus_life_1st_e01a)
0344: 21 4A D2    ld      hl,fgvideoram_code_d000+0x24A
0347: CD BF 41    call    print_hex_byte_41bf
034A: 21 57 05    ld      hl,str1stbonus60000_1_0557
034D: CD 8F 41    call    print_string_418f
0350: 3A 1B E0    ld      a,(bonus_life_2nd_e01b)
0353: 21 48 D2    ld      hl,fgvideoram_code_d000+0x248
0356: CD BF 41    call    print_hex_byte_41bf
0359: C9          ret
; ---------------------------------------------------------------------------

; shows lives (ship icons) up to a maximum of 4

main_fn_9__print_lives_ships_035a:                                   ; ...
035A: 21 1B 06    ld      hl,str10x_1_061b
035D: CD A6 41    call    wipe_string_41a6
0360: 21 29 06    ld      hl,str10x_2_0629
0363: CD A6 41    call    wipe_string_41a6
0366: 3A 00 E5    ld      a,(curr_lives_left_e500)
0369: A7          and     a                               ; any lives left?
036A: C8          ret     Z                               ; no,exit
036B: 3D          dec     a                               ; 1 left?
036C: C8          ret     Z                               ; yes,exit
036D: FE 05       cp      5                              ; more then 4?
036F: 38 02       jr      C,loc_0373                      ; no,skip
0371: 3E 04       ld      a,4                           ; max=4

loc_0373:                                                        ; ...
0373: 47          ld      b,a
0374: 21 41 D0    ld      hl,fgvideoram_code_d000+0x41

loc_0377:                                                        ; ...
0377: E5          push    hl
0378: 36 00       ld      (hl),0                        ; code  [unchecked_address]
037A: CB D4       set     2,h                            ; ptr colour
037C: 36 97       ld      (hl),$97 ; '�'               ; colour  [video_address]
037E: CB 94       res     2,h                            ; ptr code
0380: 3E 20       ld      a,$20 ; ' '			[unchecked_address]
0382: DF          rst     hl_plus_equals_a_0018                ; next column
0383: 36 01       ld      (hl),1                        ; code   [unchecked_address]
0385: CB D4       set     2,h                            ; ptr colour
0387: 36 98       ld      (hl),$98 ; '�'               ; colour   [video_address]
0389: E1          pop     hl                              ; restore addr
038A: 2B          dec     hl                              ; next column
038B: 36 10       ld      (hl),$10                     ; code   [unchecked_address]
038D: CB D4       set     2,h                            ; ptr colour
038F: 36 98       ld      (hl),$98 ; '�'               ; colour   [video_address]
0391: CB 94       res     2,h                            ; ptr code
0393: 3E 20       ld      a,$20 ; ' '
0395: DF          rst     hl_plus_equals_a_0018                ; next column
0396: 36 11       ld      (hl),$11                     ; code  [unchecked_address]

loc_0398:                                                        ; ptr colour
0398: CB D4       set     2,h
039A: 36 98       ld      (hl),$98 ; '�'               ; colour  [video_address]
039C: CB 94       res     2,h                            ; ptr code
039E: 3E 21       ld      a,$21 ; '!'
03A0: DF          rst     hl_plus_equals_a_0018                ; next column,row
03A1: 10 D4       djnz    loc_0377                         ; loop
03A3: C9          ret
; ---------------------------------------------------------------------------

main_fn_0__print_string_param_03a4:                                  ; ...
03A4: 21 6F 04    ld      hl,string_tbl_046f
03A7: 3A A4 ED    ld      a,(q_param_eda4)
03AA: EF          rst     de_eq_contents_hl_plus_2a_0028       ; get string tbl entry
03AB: EB          ex      de,hl
03AC: C3 8F 41    jp      print_string_418f
; ---------------------------------------------------------------------------

main_fn_1__wipe_string_param_03af:                                   ; ...
03AF: 21 6F 04    ld      hl,string_tbl_046f
03B2: 3A A4 ED    ld      a,(q_param_eda4)
03B5: EF          rst     de_eq_contents_hl_plus_2a_0028       ; get string tbl entry
03B6: EB          ex      de,hl
03B7: C3 A6 41    jp      wipe_string_41a6
; ---------------------------------------------------------------------------

main_fn_2__print_curr_score_03ba:                                    ; ...
03BA: 3A 01 EC    ld      a,(curr_player_ec01)
03BD: E6 01       and     1                              ; p2_e003?
03BF: C2 01 42    jp      NZ,print_p2_score_0_4201            ; yes,go
03C2: C3 EC 41    jp      print_p1_score_0_41ec
; ---------------------------------------------------------------------------

main_fn_3__print_hi_score_03c5:                                      ; ...
03C5: C3 15 42    jp      print_hi_score_0_4215
; ---------------------------------------------------------------------------

main_fn_4__print_hi_score_tbl_03c8:                                  ; ...
03C8: 11 04 00    ld      de,4
03CB: FF          rst     add_fn_to_q_0038                     ; re-queue this function
03CC: FD 21 23 E0 ld      iy,tmp_e023
03D0: FD 36 00 05 ld      (iy+$00),5                       ; 5 scores to print
03D4: 21 ED D0    ld      hl,fgvideoram_code_d000+0xED
03D7: 11 2F 04    ld      de,a1st_042f                       ; "1ST"
03DA: 0E 05       ld      c,5                           ; 5 strings

loc_03dc:                                                        ; ...
03DC: 06 03       ld      b,3                           ; 3 chars

loc_03de:                                                        ; ...
03DE: 1A          ld      a,(de)                         ; char
03DF: 13          inc     de                              ; next char
03E0: 77          ld      (hl),a                         ; code  [unchecked_address]
03E1: CB D4       set     2,h                            ; ptr colour
03E3: 36 08       ld      (hl),8                        ; colour  [video_address]
03E5: CB 94       res     2,h                            ; ptr code
03E7: 3E 20       ld      a,$20 ; ' '
03E9: DF          rst     hl_plus_equals_a_0018                ; next column
03EA: 10 F2       djnz    loc_03de
03EC: 3E 9E       ld      a,$9E ; '�'
03EE: 85          add     a,l
03EF: 6F          ld      l,a
03F0: 25          dec     h                               ; next video address
03F1: 0D          dec     c                               ; string count
03F2: 20 E8       jr      NZ,loc_03dc                     ; loop
03F4: DD 21 00 EE ld      ix,hiscore_tbl_ee00
03F8: 21 8D D1    ld      hl,fgvideoram_code_d000+0x18D
03FB: 0E 09       ld      c,9                           ; colour

loc_03fd:                                                        ; ...
03FD: DD E5       push    ix
03FF: D1          pop     de
0400: CD 97 43    call    print_score_digits_4397              ; print hi score
0403: 36 30       ld      (hl),$30 ; '0'               ; add trailing '0'  [unchecked_address]
0405: CB D4       set     2,h                            ; ptr colour
0407: 71          ld      (hl),c                         ; colour  [video_address]
0408: CB 94       res     2,h                            ; ptr code
040A: 3E 60       ld      a,$60 ; '`'
040C: DF          rst     hl_plus_equals_a_0018
040D: D5          push    de                              ; $EE03
040E: DD E1       pop     ix
0410: 06 0A       ld      b,10                          ; 10 characters

loc_0412:                                                        ; ...
0412: DD 7E 00    ld      a,(ix+$00)
0415: DD 23       inc     ix
0417: 77          ld      (hl),a                         ; code   [unchecked_address]
0418: CB D4       set     2,h                            ; ptr colour
041A: 36 05       ld      (hl),5                        ; colour  [video_address]
041C: CB 94       res     2,h                            ; ptr code
041E: 3E 20       ld      a,$20 ; ' '
0420: DF          rst     hl_plus_equals_a_0018                ; next column
0421: 10 EF       djnz    loc_0412                         ; loop
0423: 25          dec     h
0424: 25          dec     h
0425: 3E 9E       ld      a,$9E ; '�'
0427: 85          add     a,l
0428: 6F          ld      l,a
0429: FD 35 00    dec     (iy+$00)                           ; next score
042C: 20 CF       jr      NZ,loc_03fd                     ; loop
042E: C9          ret
; ---------------------------------------------------------------------------
;a1st_042f:                   .ascii '1ST'                            ; ...
;a2nd_0432:                   .ascii '2ND'
;a3rd_0435:                   .ascii '3RD'
;a4th_0438:                   .ascii '4TH'
;a5th_043b:                   .ascii '5TH'
; ---------------------------------------------------------------------------

main_fn_56__print_credits_043e:                                      ; ...
043E: 21 CB 04    ld      hl,strcredit_04cb
0441: CD 8F 41    call    print_string_418f
0444: 3A 22 E0    ld      a,(credits_e022)
0447: 21 80 D3    ld      hl,fgvideoram_code_d000+0x380
044A: 0E 01       ld      c,1                           ; colour
044C: C3 BF 41    jp      print_hex_byte_41bf
; ---------------------------------------------------------------------------

; main_fn_7(char,long,short)
main_fn_7__cls_044f:                                                 ; ...
044F: 21 02 D0    ld      hl,fgvideoram_code_d000+2
0452: 0E 1C       ld      c,$1C                        ; 28 rows

loc_0454:                                                        ; ...
0454: 06 20       ld      b,$20 ; ' '
0456: 11 20 00    ld      de,$20 ; ' '
0459: 22 23 E0    ld      (tmp_e023),hl

loc_045c:                                                        ; ...
045C: 36 20       ld      (hl),$20 ; ' '               ; code=blank			[unchecked_address]
045E: CB D4       set     2,h                            ; ptr color
0460: 36 00       ld      (hl),0                        ; colour		[video_address]
0462: CB 94       res     2,h                            ; ptr code
0464: 19          add     hl,de                          ; next column
0465: 10 F5       djnz    loc_045c                         ; 32 chars
0467: 0D          dec     c                               ; done all rows?
0468: C8          ret     Z                               ; yes,return
0469: 2A 23 E0    ld      hl,(tmp_e023)                  ; row address
046C: 2C          inc     l                               ; next row
046D: 18 E5       jr      loc_0454                         ; loop

; ---------------------------------------------------------------------------

main_fn_8__add_to_score_update_hi_068e:                              ; ...
068E: 3A 05 E0    ld      a,(vbl_lvl_0_fn_e005)
0691: 3D          dec     a                               ; attract mode?
0692: C8          ret     Z                               ; yes,exit
0693: 21 53 07    ld      hl,points_tbl_0753
0696: 3A A4 ED    ld      a,(q_param_eda4)                    ; points ordinal
0699: EF          rst     de_eq_contents_hl_plus_2a_0028       ; get points entry
069A: 21 43 EE    ld      hl,p1_score_lsb_ee43
069D: 3A 01 EC    ld      a,(curr_player_ec01)
06A0: E6 01       and     1                              ; p2_e003?
06A2: 28 03       jr      Z,loc_06a7                      ; no,skip
06A4: 21 46 EE    ld      hl,p2_score_lsb_ee46

loc_06a7:                                                        ; ...
06A7: 7E          ld      a,(hl)                         ; score byte
06A8: 83          add     a,e                            ; add points lsb
06A9: 27          daa
06AA: 77          ld      (hl),a                         ; update score byte
06AB: 2B          dec     hl                              ; next score byte
06AC: 7E          ld      a,(hl)                         ; score byte
06AD: 8A          adc     a,d                            ; add points msb
06AE: 27          daa
06AF: 77          ld      (hl),a                         ; update score byte
06B0: 47          ld      b,a                            ; save
06B1: D2 BB 06    jp      NC,loc_06bb                     ; no overflow,skip
06B4: 2B          dec     hl                              ; next score byte
06B5: 7E          ld      a,(hl)                         ; score byte
06B6: C6 01       add     a,1                           ; inc
06B8: 27          daa
06B9: 77          ld      (hl),a                         ; update score byte
06BA: 57          ld      d,a                            ; save

loc_06bb:                                                        ; ...
06BB: CD 20 07    call    chk_jap_symbol_bonus_0720
06BE: 21 04 E5    ld      hl,curr_bonus_life_1st_e504
06C1: 7E          ld      a,(hl)                         ; bonus life score
06C2: A7          and     a                               ; used?
06C3: 20 05       jr      NZ,loc_06ca                     ; no,go
06C5: 2C          inc     l                               ; next bonus life
06C6: 7E          ld      a,(hl)
06C7: A7          and     a                               ; used?
06C8: 28 12       jr      Z,loc_06dc                      ; yes,skip

loc_06ca:                                                        ; ...
06CA: 90          sub     b                               ; reached it?
06CB: 28 02       jr      Z,loc_06cf                      ; yes,go
06CD: 30 0D       jr      NC,loc_06dc                     ; no,skip

loc_06cf:                                                        ; ...
06CF: 36 00       ld      (hl),0                        ; flag bonus life used
06D1: 21 00 E5    ld      hl,curr_lives_left_e500
06D4: 34          inc     (hl)                            ; add a life
06D5: 11 00 09    ld      de,$900                      ; print lives ships
06D8: FF          rst     add_fn_to_q_0038
06D9: CD 28 47    call    snd_cmd_01_4728

loc_06dc:                                                        ; ...
06DC: 21 41 EE    ld      hl,p1_score_ee41
06DF: 3A 01 EC    ld      a,(curr_player_ec01)
06E2: E6 01       and     1                              ; p1_e002?
06E4: 28 03       jr      Z,loc_06e9                      ; yes,skip
06E6: 21 44 EE    ld      hl,p2_score_ee44

loc_06e9:                                                        ; ...
06E9: 11 47 EE    ld      de,hi_score_ee47
06EC: 1A          ld      a,(de)                         ; hi score MSB
06ED: BE          cp      (hl)                            ; curr score higher?
06EE: 38 15       jr      C,update_hi_score_0705              ; yes,go
06F0: C2 BA 03    jp      NZ,main_fn_2__print_curr_score_03ba ; lower,exit
06F3: 23          inc     hl                              ; next byte
06F4: 13          inc     de
06F5: 1A          ld      a,(de)
06F6: BE          cp      (hl)                            ; curr score higher?
06F7: 38 0C       jr      C,update_hi_score_0705              ; yes,go
06F9: C2 BA 03    jp      NZ,main_fn_2__print_curr_score_03ba ; lower,exit
06FC: 23          inc     hl                              ; next byte
06FD: 13          inc     de
06FE: 1A          ld      a,(de)
06FF: BE          cp      (hl)                            ; curr score higher?
0700: 38 03       jr      C,update_hi_score_0705              ; yes,go
0702: C2 BA 03    jp      NZ,main_fn_2__print_curr_score_03ba ; lower,exit

update_hi_score_0705:                                                ; ...
0705: 01 03 00    ld      bc,3                          ; 3 score bytes to copy
0708: 21 41 EE    ld      hl,p1_score_ee41
070B: 3A 01 EC    ld      a,(curr_player_ec01)
070E: E6 01       and     1                              ; p1_e002?
0710: 28 03       jr      Z,loc_0715                      ; yes,skip
0712: 21 44 EE    ld      hl,p2_score_ee44

loc_0715:                                                        ; ...
0715: 11 47 EE    ld      de,hi_score_ee47
0718: ED B0       ldir                                    ; copy to hi score
071A: CD 15 42    call    print_hi_score_0_4215
071D: C3 BA 03    jp      main_fn_2__print_curr_score_03ba

; =============== S U B R O U T I N E =======================================


chk_jap_symbol_bonus_0720:                                           ; ...
0720: 21 41 EE    ld      hl,p1_score_ee41
0723: 3A 01 EC    ld      a,(curr_player_ec01)
0726: E6 01       and     1                              ; p1_e002?
0728: 28 03       jr      Z,loc_072d                      ; yes,skip
072A: 21 44 EE    ld      hl,p2_score_ee44

loc_072d:                                                        ; ...
072D: 7E          ld      a,(hl)                         ; score byte MSB
072E: 0F          rrca
072F: 0F          rrca
0730: 0F          rrca
0731: 0F          rrca
0732: E6 F0       and     $F0 ; '�'                     ; low nibble to high nibble
0734: 57          ld      d,a                            ; save (x00,00[0])
0735: 23          inc     hl                              ; next score byte
0736: 7E          ld      a,(hl)                         ; score byte (middle B)
0737: 0F          rrca
0738: 0F          rrca
0739: 0F          rrca
073A: 0F          rrca
073B: E6 0F       and     $F                            ; high nibble to low nibble
073D: 82          add     a,d                            ; combine (y0,00[0])
073E: 57          ld      d,a                            ; save (xy0,00[0]) tens of thousands
073F: 3A 07 E5    ld      a,(next_jap_symbol_bonus_score_e507)
0742: FE 60       cp      $60 ; '`'                     ; score less than 600,000?
0744: D0          ret     NC                              ; no,exit
0745: 5F          ld      e,a                            ; next japanese bonus score
0746: 7A          ld      a,d                            ; curr score 10,000's
0747: BB          cp      e                               ; more than next bonus?
0748: D8          ret     C                               ; no,exit
0749: 7B          ld      a,e                            ; get bonus score
074A: C6 10       add     a,$10                        ; add 100,000
074C: 32 07 E5    ld      (next_jap_symbol_bonus_score_e507),a ; update
074F: 32 9D E0    ld      (spawn_jap_symb_flag_e09d),a        ; flag japanese symbol
0752: C9          ret
; End of function chk_jap_symbol_bonus_0720

; ---------------------------------------------------------------------------
;	.word 5                                   ; ...
;0753:                                                     ; 50 pts
;	.word 0x10                                ; 100 pts
;	.word 0x20                                ; 200 pts
;	.word 0x30                                ; 300 pts
;	.word 0x40                                ; 400 pts
;	.word 0x50                                ; 500 pts
;	.word 0x60                                ; 600 pts
;	.word 0x80                                ; 800 pts
;	.word 0x100                               ; 1,000 pts
;	.word 0x150                               ; 1,500 pts
;	.word 0x200                               ; 2,000 pts
;	.word 0x250                               ; 2,500 pts
;	.word 0x300                               ; 3,000 pts
;	.word 0x350                               ; 3,500 pts
;	.word 0x400                               ; 4,000 pts
;	.word 0x450                               ; 4,500 pts
;	.word 0x500                               ; 5,000 pts
;	.word 0x800                               ; 8,000 pts
;	.word 0x1000                              ; 10,000 pts
;	.word 0x5000                              ; 50,000 pts
; ---------------------------------------------------------------------------

main_fn_1011__scroll_left_18_rows_077b:                              ; ...
077B: CD 56 42    call    init_scroll_cnt_4256

loc_077e:                                                        ; ...
077E: CD 5C 42    call    scroll_left_1_col_425c
0781: 20 FB       jr      NZ,loc_077e
0783: C9          ret
; ---------------------------------------------------------------------------

main_fn_12__show_or_wipe_fg_title_0784:                              ; ...
0784: 3A A4 ED    ld      a,(q_param_eda4)
0787: A7          and     a                               ; display?
0788: 28 02       jr      Z,display_fg_title_078c             ; no,skip
078A: 18 29       jr      wipe_fg_title_07b5
; ---------------------------------------------------------------------------

display_fg_title_078c:                                               ; ...
078C: 21 B9 D0    ld      hl,fgvideoram_code_d000+0xB9
078F: 11 D0 07    ld      de,fg_title_code_07d0
0792: D9          exx
0793: 11 54 08    ld      de,fg_title_colour_0854
0796: D9          exx
0797: 0E 06       ld      c,6                           ; 6 rows

loc_0799:                                                        ; ...
0799: 06 16       ld      b,22                          ; 22 chars/row
079B: E5          push    hl

loc_079c:                                                        ; ...
079C: 1A          ld      a,(de)                         ; get char
079D: 13          inc     de                              ; next char
079E: C6 80       add     a,$80 ;                  ; calc code
07A0: 77          ld      (hl),a                         ; code	 [unchecked_address]
07A1: D9          exx
07A2: 1A          ld      a,(de)                         ; get colour  [unchecked_address]
07A3: 13          inc     de                              ; next colour
07A4: D9          exx
07A5: CB D4       set     2,h                            ; ptr colour
07A7: 77          ld      (hl),a                         ; colour  [video_address]
07A8: CB 94       res     2,h                            ; ptr code
07AA: 3E 20       ld      a,$20 ; ' '
07AC: DF          rst     hl_plus_equals_a_0018                ; next column
07AD: 10 ED       djnz    loc_079c                         ; loop
07AF: E1          pop     hl
07B0: 2B          dec     hl
07B1: 0D          dec     c                               ; next row                                                      ; loop
07B2: 20 E5       jr      NZ,loc_0799
07B4: C9          ret
; ---------------------------------------------------------------------------

wipe_fg_title_07b5:                                                  ; ...
07B5: 21 B9 D0    ld      hl,fgvideoram_code_d000+0xB9
07B8: 0E 06       ld      c,6                           ; 6 rows

loc_07ba:                                                        ; ...
07BA: 06 16       ld      b,22                          ; 22 chars/row
07BC: E5          push    hl

loc_07bd:                                                        ; ...
07BD: 36 20       ld      (hl),$20 ; ' '               ; blank  [unchecked_address]
07BF: CB D4       set     2,h                            ; ptr colour
07C1: 36 00       ld      (hl),0                        ; colour  [video_address]
07C3: CB 94       res     2,h                            ; ptr code
07C5: 3E 20       ld      a,$20 ; ' '
07C7: DF          rst     hl_plus_equals_a_0018                ; next column
07C8: 10 F3       djnz    loc_07bd                         ; loop
07CA: E1          pop     hl
07CB: 2B          dec     hl
07CC: 0D          dec     c                               ; next row
07CD: 20 EB       jr      NZ,loc_07ba                     ; loop
07CF: C9          ret
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------

main_fn_13__show_bombs_08fa:                                         ; ...
08FA: 21 37 06    ld      hl,str19x_0637
08FD: CD A6 41    call    wipe_string_41a6
0900: 3A 06 E5    ld      a,(curr_num_bombs_e506)
0903: A7          and     a
0904: C8          ret     Z
0905: FE 0F       cp      15                             ; more than 15?
0907: 38 02       jr      C,loc_090b                      ; no,skip
0909: 3E 0F       ld      a,15                          ; only display 15

loc_090b:                                                        ; ...
090B: 21 A0 D3    ld      hl,fgvideoram_code_d000+0x3A0     ; start bottom RH corner
090E: 47          ld      b,a

loc_090f:                                                        ; ...
090F: 36 02       ld      (hl),2                        ; code ($102=bomb)  [unchecked_address]
0911: CB D4       set     2,h                            ; ptr colour
0913: 36 96       ld      (hl),$96 ; '�'               ; colour			[video_address]
0915: CB 94       res     2,h                            ; ptr code
0917: 7D          ld      a,l
0918: D6 20       sub     $20 ; ' '                     ; previous column
091A: 6F          ld      l,a
091B: 30 01       jr      NC,loc_091e
091D: 25          dec     h                               ; adjust for address wrap

loc_091e:                                                        ; ...
091E: 10 EF       djnz    loc_090f                         ; loop
0920: C9          ret
; ---------------------------------------------------------------------------

vbl_0_fn_0__attract_text_0921:                                       ; ...
0921: 3A 06 E0    ld      a,(vbl_lvl_1_fn_e006)
0924: F7          rst    $30		  ; [jump_to_jump_table] [nb_entries=8]
; ---------------------------------------------------------------------------
	.word vbl_0_0_fn_0__init_09e2
	.word vbl_0_0_fn_1__inc_bg_prerender_buf_09eb
	.word vbl_0_0_fn_2__print_1up_score_credits_09f6
; the following functions are never executed
	.word vbl_0_0_fn_3__check_1pstart_0a13
	.word vbl_0_0_fn_4__handle_sprite_test_0a28
	.word vbl_0_0_fn_5__check_1pstart_0a35
	.word vbl_0_0_fn_6__delay_0a52
	.word vbl_0_0_fn_7__handle_scroll_test_display_0a6e
; ---------------------------------------------------------------------------

vbl_0_fn_1__attract_mode_0935:                                       ; ...
0935: 21 73 09    ld      hl,vbl_0_1_fn_23to26__check_freeplay_wait_credits_0973 ; [push_function]
0938: E5          push    hl                              ; set return address 
0939: 3A 06 E0    ld      a,(vbl_lvl_1_fn_e006)
093C: F7          rst    $30		  ; [jump_to_jump_table] [nb_entries=27]
; ---------------------------------------------------------------------------
	.word vbl_0_1_fn_0__render_hi_score_screen_0aed
	.word vbl_0_1_fn_1__wait_timer_0b0b
	.word vbl_0_1_fn_2__reset_attract_mode_gameplay_0b13
	.word vbl_0_1_fn_3__init_attract_mode_map_0b30
	.word vbl_0_1_fn_4__init_attract_mode_ship_0b72
	.word vbl_0_1_fn_5__attract_mode_gameplay_0b8e
	.word vbl_0_1_fn_6__end_attract_hiscores_0bc3
	.word vbl_0_1_fn_7__scroll_playfield_0c1b
	.word vbl_0_1_fn_8__init_objs_for_pow_instruct_0c2a
	.word vbl_0_1_fn_9__pow_instruct_0c79
	.word vbl_0_1_fn_10__bomb_instruct_init_0cd3
	.word vbl_0_1_fn_11_0ce0
	.word vbl_0_1_fn_12__show_combo_bonus_0d14
	.word vbl_0_1_fn_13__init_big_aliens_0d38
	.word vbl_0_1_fn_14__big_alien_instruct_collect_pow_0d89
	.word vbl_0_1_fn_15__big_alien_instruct_fire_bomb_0dd7
	.word vbl_0_1_fn_16__big_alien_instruct_explode_fly_0e24
	.word vbl_0_1_fn_17__big_alien_instruct_move_left_0e50
	.word vbl_0_1_fn_18__big_alien_instruct_shoot_viking_0e7a
	.word vbl_0_1_fn_19__big_alien_instruct_explode_viking_0eca
	.word vbl_0_1_fn_20__big_alien_instruct_move_to_bat_0ef0
	.word vbl_0_1_fn_21__big_alien_instruct_explode_bat_0f24
	.word vbl_0_1_fn_22__end_instructions_0f64
	.word vbl_0_1_fn_23to26__check_freeplay_wait_credits_0973
	.word vbl_0_1_fn_23to26__check_freeplay_wait_credits_0973
	.word vbl_0_1_fn_23to26__check_freeplay_wait_credits_0973
	.word vbl_0_1_fn_23to26__check_freeplay_wait_credits_0973
; ---------------------------------------------------------------------------

vbl_0_1_fn_23to26__check_freeplay_wait_credits_0973:                 ; ...
0973: 3A 10 E0    ld      a,(freeplay_e010)
0976: A7          and     a                               ; freeplay_e010?
0977: 20 08       jr      NZ,check_freeplay_start_0981        ; yes,skip
0979: 3A 22 E0    ld      a,(credits_e022)
097C: A7          and     a                               ; any credits_e022?
097D: C8          ret     Z                               ; no,return
097E: C3 CC 0F    jp      vbl_inc_lvl_0_reset_lvl_1_fns_0fcc   ; goto main fn 1
; ---------------------------------------------------------------------------

check_freeplay_start_0981:                                           ; ...
0981: 3A 01 E0    ld      a,(system_e001)
0984: E6 03       and     3                              ; 1P/2P start pressed?
0986: C8          ret     Z                               ; no,return
0987: CB 47       bit     0,a                            ; 1P?
0989: C2 B3 09    jp      NZ,handle_1pstart_09b3
098C: C3 C6 09    jp      handle_2pstart_09c6
; ---------------------------------------------------------------------------

vbl_0_fn_2__check_start_098f:                                        ; ...
098F: 21 A1 09    ld      hl,check_and_handle_start_09a1	; [push_function]
0992: E5          push    hl                              ; set return address
0993: 3A 06 E0    ld      a,(vbl_lvl_1_fn_e006)
0996: F7          rst    $30		  ; [jump_to_jump_table] [nb_entries=5]
; ---------------------------------------------------------------------------
	.word vbl_0_2_fn_0__cls_print_push_start_0f7b
	.word vbl_0_2_fn_1__render_attract_mode_text_0f8e
	.word vbl_0_2_fn_2__wait_2_credits_0fb3
	.word vbl_0_2_fn_3__show_lives_bonus_title_0fbc
	.word locret_0fcb
; ---------------------------------------------------------------------------

check_and_handle_start_09a1:                                         ; ...
09A1: 3A 01 E0    ld      a,(system_e001)
09A4: E6 03       and     3                              ; 1P/2P start pressed?
09A6: C8          ret     Z                               ; no,return
09A7: CB 47       bit     0,a                            ; 1P START?
09A9: 20 08       jr      NZ,handle_1pstart_09b3              ; yes,skip
09AB: 3A 06 E0    ld      a,(vbl_lvl_1_fn_e006)
09AE: FE 03       cp      3                              ; 0-2?
09B0: D8          ret     C                               ; yes,exit
09B1: 18 13       jr      handle_2pstart_09c6
; ---------------------------------------------------------------------------

handle_1pstart_09b3:                                                 ; ...
09B3: 3A 22 E0    ld      a,(credits_e022)
09B6: D6 01       sub     1                              ; sub 1 credit
09B8: 27          daa
09B9: 32 22 E0    ld      (credits_e022),a
09BC: 16 06       ld      d,6                           ; print credits_e022
09BE: FF          rst     add_fn_to_q_0038
09BF: AF          xor     a                               ; flag 1P game
09C0: 32 00 EC    ld      (two_p_game_ec00),a
09C3: C3 D7 09    jp      loc_09d7
; ---------------------------------------------------------------------------

handle_2pstart_09c6:                                                 ; ...
09C6: 3A 22 E0    ld      a,(credits_e022)
09C9: D6 02       sub     2                              ; sub 2 credits_e022
09CB: 27          daa
09CC: 32 22 E0    ld      (credits_e022),a
09CF: 16 06       ld      d,6
09D1: FF          rst     add_fn_to_q_0038                     ; print credits_e022
09D2: 3E 01       ld      a,1                           ; flag 2P game
09D4: 32 00 EC    ld      (two_p_game_ec00),a

loc_09d7:                                                        ; ...
09D7: 11 01 0C    ld      de,$C01                      ; wipe title
09DA: FF          rst     add_fn_to_q_0038
09DB: AF          xor     a
09DC: 32 01 EC    ld      (curr_player_ec01),a
09DF: C3 CC 0F    jp      vbl_inc_lvl_0_reset_lvl_1_fns_0fcc
; ---------------------------------------------------------------------------

vbl_0_0_fn_0__init_09e2:                                             ; ...
09E2: CD DC 47    call    init_curr_player_map_data_47dc
09E5: CD 89 40    call    init_bg_prerender_and_cls_4089
09E8: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_0_fn_1__inc_bg_prerender_buf_09eb:                             ; ...
09EB: CD A6 40    call    inc_bg_prerender_buffer_40a6
09EE: 3A 48 E0    ld      a,(bg_lines_to_render_e048)
09F1: A7          and     a                               ; any left?
09F2: C0          ret     NZ                              ; yes,return
09F3: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_0_fn_2__print_1up_score_credits_09f6:                          ; ...
09F6: 11 00 00    ld      de,0                          ; print 1UP
09F9: FF          rst     add_fn_to_q_0038
09FA: 1E 02       ld      e,2                           ; print CREDIT
09FC: FF          rst     add_fn_to_q_0038
09FD: 16 02       ld      d,2                           ; print curr score
09FF: FF          rst     add_fn_to_q_0038
0A00: 16 03       ld      d,3                           ; print hi score
0A02: FF          rst     add_fn_to_q_0038
0A03: 16 06       ld      d,6                           ; print credits_e022
0A05: FF          rst     add_fn_to_q_0038
0A06: C3 EA 0A    jp      jp_vbl_inc_lvl_0_reset_lvl_1_fns_0aea
; ---------------------------------------------------------------------------

; hereafter are some test screens
; which cannot be reached from unpatched code

0A09: 11 0F 00    ld      de,$F
0A0C: FF          rst     add_fn_to_q_0038
0A0D: CD CC 40    call    show_char_test_screen_40cc
0A10: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------
; *** NOT USED

vbl_0_0_fn_3__check_1pstart_0a13:                                    ; ...
0A13: CD 10 41    call    sub_4110
0A16: 3A 00 E0    ld      a,(vblank_tick_e000)
0A19: E6 07       and     7
0A1B: C0          ret     NZ
0A1C: 3A 01 E0    ld      a,(system_e001)
0A1F: E6 01       and     1                              ; 1PSTART pressed?
0A21: C8          ret     Z                               ; no,return
0A22: 16 07       ld      d,7                           ; cls
0A24: FF          rst     add_fn_to_q_0038
0A25: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------
; *** NOT USED

vbl_0_0_fn_4__handle_sprite_test_0a28:                               ; ...
0A28: CD 99 42    call    clear_pressed_flags_4299
0A2B: CD A1 42    call    show_sprite_test_screen_42a1
0A2E: 11 0E 00    ld      de,$E                        ; print OBJ CHARA
0A31: FF          rst     add_fn_to_q_0038
0A32: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------
; *** NOT USED

vbl_0_0_fn_5__check_1pstart_0a35:                                    ; ...
0A35: CD 0D 43    call    debounce_inputs_430d
0A38: 3A 00 E0    ld      a,(vblank_tick_e000)
0A3B: E6 07       and     7
0A3D: C0          ret     NZ
0A3E: 3A 01 E0    ld      a,(system_e001)
0A41: E6 01       and     1                              ; 1P START?
0A43: C8          ret     Z                               ; no,return
0A44: 16 07       ld      d,7                           ; cls
0A46: FF          rst     add_fn_to_q_0038
0A47: CD A1 02    call    hide_all_sprites_02a1
0A4A: 3E 3C       ld      a,60                          ; init
0A4C: 32 25 E0    ld      (timer_e025),a
0A4F: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------
; *** NOT USED

vbl_0_0_fn_6__delay_0a52:                                            ; ...
0A52: 3A 25 E0    ld      a,(timer_e025)
0A55: A7          and     a                               ; expired?
0A56: 20 11       jr      NZ,loc_0a69                     ; no,tick & exit
0A58: CD DB 47    call    nullsub_47db
0A5B: 3A 01 E0    ld      a,(system_e001)
0A5E: E6 01       and     1                              ; 1P START?
0A60: C8          ret     Z                               ; no,return
0A61: 21 25 E0    ld      hl,timer_e025
0A64: 36 3C       ld      (hl),60                       ; init
0A66: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

loc_0a69:                                                        ; ...
0A69: 21 25 E0    ld      hl,timer_e025
0A6C: 35          dec     (hl)
0A6D: C9          ret
; ---------------------------------------------------------------------------
; *** NOT USED

vbl_0_0_fn_7__handle_scroll_test_display_0a6e:                       ; ...
0A6E: 3A 25 E0    ld      a,(timer_e025)
0A71: A7          and     a
0A72: 20 F5       jr      NZ,loc_0a69
0A74: CD 78 0A    call    handle_scroll_test_display_tick_0a78
0A77: C9          ret

; =============== S U B R O U T I N E =======================================


handle_scroll_test_display_tick_0a78:                                ; ...
0A78: CD 9B 0A    call    handle_scroll_lr_test_display_0a9b
0A7B: CD 7F 0A    call    handle_scroll_ud_test_display_0a7f
0A7E: C9          ret
; End of function handle_scroll_test_display_tick_0a78


; =============== S U B R O U T I N E =======================================


handle_scroll_ud_test_display_0a7f:                                  ; ...
0A7F: 2A 46 E0    ld      hl,(scroll_plus1_shadow_e046)
0A82: 3A 0B E0    ld      a,(curr_player_up_e00b)
0A85: A7          and     a                               ; up?
0A86: 20 07       jr      NZ,handle_scroll_u_test_0a8f        ; yes,handle
0A88: 3A 0A E0    ld      a,(curr_player_down_e00a)
0A8B: A7          and     a                               ; down?
0A8C: 20 07       jr      NZ,handle_scroll_d_test_0a95        ; yes,handle
0A8E: C9          ret
; ---------------------------------------------------------------------------

handle_scroll_u_test_0a8f:                                           ; ...
0A8F: 2B          dec     hl
0A90: 22 46 E0    ld      (scroll_plus1_shadow_e046),hl
0A93: 18 22       jr      loc_0ab7
; ---------------------------------------------------------------------------

handle_scroll_d_test_0a95:                                           ; ...
0A95: 23          inc     hl
0A96: 22 46 E0    ld      (scroll_plus1_shadow_e046),hl
0A99: 18 1C       jr      loc_0ab7
; End of function handle_scroll_ud_test_display_0a7f


; =============== S U B R O U T I N E =======================================


handle_scroll_lr_test_display_0a9b:                                  ; ...
0A9B: 2A 44 E0    ld      hl,(scroll_shadow_e044)
0A9E: 3A 08 E0    ld      a,(curr_player_right_e008)
0AA1: A7          and     a                               ; right?
0AA2: 20 07       jr      NZ,handle_scroll_r_test_0aab        ; yes,handle
0AA4: 3A 09 E0    ld      a,(curr_player_left_e009)
0AA7: A7          and     a                               ; left?
0AA8: 20 07       jr      NZ,handle_scroll_l_test_0ab1        ; yes,handle
0AAA: C9          ret
; ---------------------------------------------------------------------------

handle_scroll_r_test_0aab:                                           ; ...
0AAB: 2B          dec     hl
0AAC: 22 44 E0    ld      (scroll_shadow_e044),hl             ; update scroll hw shadow
0AAF: 18 06       jr      loc_0ab7
; ---------------------------------------------------------------------------

handle_scroll_l_test_0ab1:                                           ; ...
0AB1: 23          inc     hl
0AB2: 22 44 E0    ld      (scroll_shadow_e044),hl             ; update scroll hw shadow
0AB5: 18 00       jr      loc_0ab7
; ---------------------------------------------------------------------------

loc_0ab7:                                                        ; ...
0AB7: 21 7D D0    ld      hl,fgvideoram_code_d000+0x7D
0ABA: 36 56       ld      (hl),$56 ; 'V'               ; code  [unchecked_address]
0ABC: CB D4       set     2,h                            ; ptr colour
0ABE: 36 08       ld      (hl),8                        ; colour  [video_address]
0AC0: 21 7B D0    ld      hl,fgvideoram_code_d000+0x7B
0AC3: 36 48       ld      (hl),$48 ; 'H'               ; code  [unchecked_address]
0AC5: CB D4       set     2,h                            ; ptr colour
0AC7: 36 08       ld      (hl),8                        ; colour  [video_address]
0AC9: 3E 08       ld      a,8
0ACB: 4F          ld      c,a
0ACC: 3A 45 E0    ld      a,(scroll_shadow_e044+1)
0ACF: 21 DD D0    ld      hl,fgvideoram_code_d000+0xDD
0AD2: CD BF 41    call    print_hex_byte_41bf
0AD5: 3A 44 E0    ld      a,(scroll_shadow_e044)
0AD8: CD BF 41    call    print_hex_byte_41bf
0ADB: 3A 47 E0    ld      a,(scroll_plus1_shadow_e046+1)
0ADE: 21 DB D0    ld      hl,fgvideoram_code_d000+0xDB
0AE1: CD BF 41    call    print_hex_byte_41bf
0AE4: 3A 46 E0    ld      a,(scroll_plus1_shadow_e046)
0AE7: C3 BF 41    jp      print_hex_byte_41bf
; End of function handle_scroll_lr_test_display_0a9b

; ---------------------------------------------------------------------------

jp_vbl_inc_lvl_0_reset_lvl_1_fns_0aea:                               ; ...
0AEA: C3 CC 0F    jp      vbl_inc_lvl_0_reset_lvl_1_fns_0fcc
; ---------------------------------------------------------------------------

vbl_0_1_fn_0__render_hi_score_screen_0aed:                           ; ...
0AED: 16 04       ld      d,4                           ; print hi score table
0AEF: FF          rst     add_fn_to_q_0038
0AF0: 21 25 E0    ld      hl,timer_e025
0AF3: 36 00       ld      (hl),0                        ; init
0AF5: 11 17 01    ld      de,$117                      ; wipe str19x_0637
0AF8: FF          rst     add_fn_to_q_0038
0AF9: 16 06       ld      d,6                           ; print credits_e022
0AFB: FF          rst     add_fn_to_q_0038
0AFC: 11 11 00    ld      de,$11                       ; print (c) CAPCOM 1984
0AFF: FF          rst     add_fn_to_q_0038
0B00: 11 01 0C    ld      de,$C01                      ; wipe title
0B03: FF          rst     add_fn_to_q_0038
0B04: 11 00 0F    ld      de,$F00                      ; show attract mode title
0B07: FF          rst     add_fn_to_q_0038
0B08: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_1_fn_1__wait_timer_0b0b:                                       ; ...
0B0B: 21 25 E0    ld      hl,timer_e025
0B0E: 35          dec     (hl)
0B0F: C0          ret     NZ
0B10: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_1_fn_2__reset_attract_mode_gameplay_0b13:                      ; ...
0B13: 21 A0 E0    ld      hl,unk_e0a0
0B16: 11 A1 E0    ld      de,unk_e0a1
0B19: 36 00       ld      (hl),0
0B1B: 01 5E 06    ld      bc,$65E
0B1E: ED B0       ldir                                    ; zero $E0A0-$E6FF
0B20: CD DE 0B    call    zero_object_data_0bde
0B23: CD 7B 2A    call    init_rand_2a7b
0B26: AF          xor     a
0B27: 32 00 E0    ld      (vblank_tick_e000),a
0B2A: CD 2C 2B    call    reset_some_stuff_2b2c
0B2D: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_1_fn_3__init_attract_mode_map_0b30:                            ; ...
0B30: 21 70 EF    ld      hl,attract_mode_planet_ef70
0B33: 7E          ld      a,(hl)                         ; get planet
0B34: FE 03       cp      3                              ; 0-2?
0B36: 38 04       jr      C,loc_0b3c                      ; yes,go
0B38: 36 00       ld      (hl),0                        ; reset to 0
0B3A: 3E 00       ld      a,0

loc_0b3c:                                                        ; ...
0B3C: 87          add     a,a                            ; x2
0B3D: 87          add     a,a                            ; offset into table
0B3E: 34          inc     (hl)                            ; next planet
0B3F: 21 66 0B    ld      hl,attract_mode_gameplay_init_tbl_0b66
0B42: E7          rst     content_hl_plus_a_0020               ; ptr entry
0B43: 32 00 E5    ld      (curr_lives_left_e500),a
0B46: 23          inc     hl
0B47: 7E          ld      a,(hl)
0B48: 32 01 E5    ld      (byte_e501),a                  ; ???
0B4B: 23          inc     hl
0B4C: 7E          ld      a,(hl)
0B4D: 32 02 E5    ld      (map_planet_e502),a
0B50: 23          inc     hl
0B51: 7E          ld      a,(hl)
0B52: 32 03 E5    ld      (map_area_e503),a
0B55: CD 46 2B    call    init_planet_area_data_2b46
0B58: CD DC 47    call    init_curr_player_map_data_47dc
0B5B: AF          xor     a
0B5C: 32 C8 E0    ld      (formations_destroyed_cnt_e0c8),a
0B5F: 11 00 0A    ld      de,$A00                      ; scroll left 18 rows
0B62: FF          rst     add_fn_to_q_0038
0B63: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------
; attract mode gameplay initialisation data
; initialises curr_lives_left_e500,$E501,map_planet_e502,map_area_e503
; ---------------------------------------------------------------------------

vbl_0_1_fn_4__init_attract_mode_ship_0b72:                           ; ...
0B72: CD 98 48    call    build_bg_prerender_and_test_4898
0B75: C0          ret     NZ
0B76: 3E 04       ld      a,4                           ; 4 bombs for attract mode
0B78: 32 06 E5    ld      (curr_num_bombs_e506),a
0B7B: CD 7D 1C    call    init_bullet_and_bomb_objs_1c7d
0B7E: CD 97 1A    call    init_player_sprite_1a97
0B81: CD EF 15    call    init_ship_obj_and_bomb_tbl_15ef
0B84: CD 6D 47    call    play_snd_128_476d
0B87: 11 00 0C    ld      de,$C00                      ; show title
0B8A: FF          rst     add_fn_to_q_0038
0B8B: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_1_fn_5__attract_mode_gameplay_0b8e:                            ; ...
0B8E: CD 1E 6A    call    update_aiming_table_6a1e
0B91: CD EB 2B    call    tick_timers_2beb
0B94: CD 3B 2C    call    spawn_e200_objects_2c3b
0B97: CD A1 16    call    attract_mode_move_ship_16a1          ; also bombs
0B9A: CD F4 49    call    sub_49f4                        ; map stuff
0B9D: CD 9B 1C    call    handle_firing_bullets_and_upd_bombs_1c9b
0BA0: CD BE 20    call    update_e200_objects_20be             ; also fires
0BA3: CD 22 37    call    spawn_large_alien_3722
0BA6: CD A4 37    call    update_large_aliens_37a4             ; also fires
0BA9: CD 99 29    call    update_alien_bullets_2999
0BAC: CD 94 34    call    update_pickup_3494
0BAF: CD D6 43    call    check_objs_hit_43d6
0BB2: 3A 00 E1    ld      a,(ship_obj_e100)
0BB5: A7          and     a                               ; active?
0BB6: C0          ret     NZ                              ; yes,exit
0BB7: CD 9D 47    call    snd_cmd_08_479d
0BBA: CD A1 02    call    hide_all_sprites_02a1
0BBD: CD B8 40    call    clear_bg_via_renderer_40b8
0BC0: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_1_fn_6__end_attract_hiscores_0bc3:                             ; ...
0BC3: CD A6 40    call    inc_bg_prerender_buffer_40a6
0BC6: C0          ret     NZ
0BC7: 11 00 0F    ld      de,$F00                      ; show attract mode title
0BCA: FF          rst     add_fn_to_q_0038
0BCB: 11 01 0C    ld      de,$C01                      ; wipe title
0BCE: FF          rst     add_fn_to_q_0038
0BCF: CD DE 0B    call    zero_object_data_0bde
0BD2: 3E 24       ld      a,$24 ; '$'
0BD4: 32 25 E0    ld      (timer_e025),a
0BD7: 11 00 0A    ld      de,$A00                      ; scroll hiscores left
0BDA: FF          rst     add_fn_to_q_0038
0BDB: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6

; =============== S U B R O U T I N E =======================================


zero_object_data_0bde:                                               ; ...
0BDE: 21 00 E2    ld      hl,e200_obj_tbl_e200
0BE1: 06 09       ld      b,9                           ; 9 objects to zero
0BE3: CD 10 0C    call    zero_16_at_hl_b_times_0c10
0BE6: 21 60 E1    ld      hl,large_alien_obj_tbl_e160
0BE9: 06 03       ld      b,3                           ; 3 objects to zero
0BEB: CD 10 0C    call    zero_16_at_hl_b_times_0c10
0BEE: 21 A0 E2    ld      hl,alien_bullet_obj_tbl_e2a0       ; *** BUG - benign code
0BF1: 06 06       ld      b,6                           ; *** BUG - benign code
0BF3: 21 00 E1    ld      hl,ship_obj_e100
0BF6: 06 01       ld      b,1                           ; 1 object to zero
0BF8: CD 10 0C    call    zero_16_at_hl_b_times_0c10
0BFB: 21 10 E1    ld      hl,bullet_obj_tbl_e110
0BFE: 06 04       ld      b,4                           ; 4 objects to zero
0C00: CD 10 0C    call    zero_16_at_hl_b_times_0c10
0C03: 21 50 E1    ld      hl,bomb_obj_e150
0C06: 06 01       ld      b,1                           ; 1 object to zero
0C08: CD 10 0C    call    zero_16_at_hl_b_times_0c10
0C0B: 21 10 EF    ld      hl,spriteram_shadow_ef00+0x10     ; set s4.code as base
0C0E: 06 04       ld      b,4                           ; zero sprites 4-19
; End of function zero_object_data_0bde


; =============== S U B R O U T I N E =======================================


zero_16_at_hl_b_times_0c10:                                          ; ...
0C10: 0E 10       ld      c,16

loc_0c12:                                                        ; ...
0C12: 36 00       ld      (hl),0
0C14: 2C          inc     l
0C15: 0D          dec     c
0C16: 20 FA       jr      NZ,loc_0c12
0C18: 10 F6       djnz    zero_16_at_hl_b_times_0c10
0C1A: C9          ret
; End of function zero_16_at_hl_b_times_0c10

; ---------------------------------------------------------------------------

vbl_0_1_fn_7__scroll_playfield_0c1b:                                 ; ...
0C1B: 2A 46 E0    ld      hl,(scroll_plus1_shadow_e046)
0C1E: 2B          dec     hl
0C1F: 22 46 E0    ld      (scroll_plus1_shadow_e046),hl
0C22: 21 25 E0    ld      hl,timer_e025
0C25: 35          dec     (hl)
0C26: C0          ret     NZ
0C27: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_1_fn_8__init_objs_for_pow_instruct_0c2a:                       ; ...
0C2A: AF          xor     a                               ; bombs
0C2B: 32 06 E5    ld      (curr_num_bombs_e506),a
0C2E: 11 00 0D    ld      de,$D00
0C31: FF          rst     add_fn_to_q_0038                     ; show bombs
0C32: 21 8C 2F    ld      hl,pow_instruct_formation_1_tbl_2f8c
0C35: CD DB 0F    call    init_objs_at_e200_from_tbl_0fdb
0C38: 3E 78       ld      a,120
0C3A: 32 02 EF    ld      (spriteram_shadow_ef00+2),a         ; s0.y
0C3D: 3E 10       ld      a,16
0C3F: 32 03 EF    ld      (spriteram_shadow_ef00+3),a         ; s0.x
0C42: 3E 02       ld      a,2
0C44: 32 00 EF    ld      (spriteram_shadow_ef00),a           ; s0.code (player ship)
0C47: AF          xor     a
0C48: 32 01 EF    ld      (spriteram_shadow_ef00+1),a         ; s0.colour
0C4B: 32 9C E0    ld      (pow_instruct_aliens_destroyed_e09c),a
0C4E: 32 A4 E0    ld      (area_max_alien_bullets_e0a4),a     ; init
0C51: 3D          dec     a
0C52: 32 00 E1    ld      (ship_obj_e100),a                   ; flag active
0C55: 21 25 E0    ld      hl,timer_e025
0C58: 36 00       ld      (hl),0
0C5A: FD 21 5C EF ld      iy,spriteram_shadow_ef00+0x5C     ; s23.code
0C5E: DD 21 90 E1 ld      ix,pickup_obj_e190
0C62: FD 36 02 78 ld      (iy+$02),120                     ; s23.y
0C66: FD 36 03 50 ld      (iy+$03),80                      ; s23.x
0C6A: FD 36 00 2D ld      (iy+$00),$2D ; '-'              ; s23.code (POW)
0C6E: DD 36 05 00 ld      (ix+$05),0                       ; obj type=POW
0C72: DD 36 00 FF ld      (ix+$00),$FF                    ; obj state (active)
0C76: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_1_fn_9__pow_instruct_0c79:                                     ; ...
0C79: 21 03 EF    ld      hl,spriteram_shadow_ef00+3        ; s0.x
0C7C: 3A 90 E1    ld      a,(pickup_obj_e190)
0C7F: A7          and     a                               ; inactive?
0C80: 28 0E       jr      Z,end_pow_instruction_0c90          ; yes,go
0C82: 34          inc     (hl)                            ; move ship up
0C83: DD 21 90 E1 ld      ix,pickup_obj_e190
0C87: FD 21 5C EF ld      iy,spriteram_shadow_ef00+0x5C     ; s23.code
0C8B: CD 30 36    call    handle_pickup_3630
0C8E: 18 06       jr      loc_0c96
; ---------------------------------------------------------------------------

end_pow_instruction_0c90:                                            ; ...
0C90: 7E          ld      a,(hl)                         ; s0.x
0C91: FE 11       cp      17
0C93: 38 01       jr      C,loc_0c96                      ; no,go
0C95: 35          dec     (hl)                            ; move ship down
; just a flag to avoid calling unneccessary code?

loc_0c96:                                                        ; ...
0C96: 3A 9C E0    ld      a,(pow_instruct_aliens_destroyed_e09c)
0C99: A7          and     a
0C9A: 20 09       jr      NZ,loc_0ca5
0C9C: CD BE 20    call    update_e200_objects_20be
0C9F: CD D6 43    call    check_objs_hit_43d6
0CA2: CD 4B 1E    call    update_bomb_1e4b

loc_0ca5:                                                        ; ...
0CA5: 3A 00 E0    ld      a,(vblank_tick_e000)
0CA8: E6 01       and     1
0CAA: C0          ret     NZ
0CAB: 21 25 E0    ld      hl,timer_e025
0CAE: 7E          ld      a,(hl)
0CAF: FE CD       cp      205                            ; time to fire bomb?
0CB1: CA CF 0C    jp      Z,pow_instruct_fire_bomb_0ccf       ; yes,go
0CB4: FE A5       cp      165                            ; aliens destroyed?
0CB6: CA C3 0C    jp      Z,loc_0cc3                      ; yes,go
0CB9: FE 75       cp      117                            ; done?
0CBB: CA D6 0F    jp      Z,next_vbl_lvl_1_fn_0fd6            ; yes,go
0CBE: 35          dec     (hl)                            ; timer_e025 tick
0CBF: C0          ret     NZ                              ; not done,exit
0CC0: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

loc_0cc3:                                                        ; ...
0CC3: 35          dec     (hl)                            ; timer_e025 tick
0CC4: 21 9C E0    ld      hl,pow_instruct_aliens_destroyed_e09c
0CC7: 34          inc     (hl)
0CC8: C9          ret
; ---------------------------------------------------------------------------
; *** UNUSED code?
0CC9: 35          dec     (hl)                            ; timer_e025 tick
0CCA: 21 9C E0    ld      hl,pow_instruct_aliens_destroyed_e09c
0CCD: 35          dec     (hl)
0CCE: C9          ret
; ---------------------------------------------------------------------------

pow_instruct_fire_bomb_0ccf:                                         ; ...
0CCF: 35          dec     (hl)                            ; timer_e025 tick
0CD0: C3 0B 1E    jp      start_bomb_1e0b
; ---------------------------------------------------------------------------

vbl_0_1_fn_10__bomb_instruct_init_0cd3:                              ; ...
0CD3: 21 E9 2F    ld      hl,bomb_instruct_formation_tbl_2fe9
0CD6: CD DB 0F    call    init_objs_at_e200_from_tbl_0fdb
0CD9: AF          xor     a
0CDA: 32 25 E0    ld      (timer_e025),a
0CDD: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_1_fn_11_0ce0:                                                ; ...
0CE0: CD A5 1C    call    update_sprite_bullets_1ca5
0CE3: CD BE 20    call    update_e200_objects_20be
0CE6: CD D6 43    call    check_objs_hit_43d6
0CE9: CD F5 0C    call    init_combo_bonus_sequence_0cf5
0CEC: 3A 00 E0    ld      a,(vblank_tick_e000)
0CEF: E6 07       and     7
0CF1: C0          ret     NZ
0CF2: C3 5F 1D    jp      handle_firing_1d5f

; =============== S U B R O U T I N E =======================================


init_combo_bonus_sequence_0cf5:                                      ; ...
0CF5: 3A 00 E0    ld      a,(vblank_tick_e000)
0CF8: E6 01       and     1
0CFA: C8          ret     Z
0CFB: 21 25 E0    ld      hl,timer_e025
0CFE: 35          dec     (hl)
0CFF: 7E          ld      a,(hl)
0D00: FE AD       cp      173                            ; time to ???
0D02: C0          ret     NZ                              ; no,exit
0D03: 21 25 E0    ld      hl,timer_e025
0D06: 36 00       ld      (hl),0                        ; reset timer_e025
0D08: 3E 35       ld      a,$35 ; '5'                  ; code='500'
0D0A: 32 20 EF    ld      (spriteram_shadow_ef00+0x20),a      ; s8.code
0D0D: AF          xor     a
0D0E: 32 00 E0    ld      (vblank_tick_e000),a
0D11: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_1_fn_12__show_combo_bonus_0d14:                                ; ...
0D14: CD A5 1C    call    update_sprite_bullets_1ca5
0D17: 3A 00 E0    ld      a,(vblank_tick_e000)
0D1A: E6 1F       and     $1F                           ; time to show next bonus?
0D1C: C0          ret     NZ                              ; no,exit
0D1D: 21 25 E0    ld      hl,timer_e025
0D20: 7E          ld      a,(hl)                         ; get bonus ordinal
0D21: 34          inc     (hl)                            ; next bonus
0D22: FE 09       cp      9                              ; done all bonuses?
0D24: CA D6 0F    jp      Z,next_vbl_lvl_1_fn_0fd6            ; yes,go
0D27: 21 2F 0D    ld      hl,bonus_sprite_codes_0d2f
0D2A: E7          rst     content_hl_plus_a_0020
0D2B: 32 20 EF    ld      (spriteram_shadow_ef00+0x20),a      ; s8.code
0D2E: C9          ret
; ---------------------------------------------------------------------------
bonus_sprite_codes_0d2f:                                             ; ...
; ---------------------------------------------------------------------------

vbl_0_1_fn_13__init_big_aliens_0d38:                                 ; ...
0D38: DD 21 00 E2 ld      ix,e200_obj_tbl_e200               ; 'viking'
0D3C: FD 21 20 EF ld      iy,spriteram_shadow_ef00+0x20     ; s8.code
0D40: 3E 00       ld      a,0                           ; obj type = viking
0D42: 06 40       ld      b,64                          ; sprite y
0D44: CD 3A 10    call    init_big_alien_103a
0D47: DD 21 20 E2 ld      ix,e200_obj_tbl_e200+0x20         ; 'fly'
0D4B: FD 21 28 EF ld      iy,spriteram_shadow_ef00+0x28     ; s10.code
0D4F: 3E 01       ld      a,1                           ; obj type = 'fly'
0D51: 06 70       ld      b,112                         ; sprite y
0D53: CD 3A 10    call    init_big_alien_103a
0D56: DD 21 40 E2 ld      ix,e200_obj_tbl_e200+0x40         ; 'bat'
0D5A: FD 21 30 EF ld      iy,spriteram_shadow_ef00+0x30     ; s12.code
0D5E: 3E 02       ld      a,2                           ; obj type = 'bat'
0D60: 06 A0       ld      b,160                         ; sprite y
0D62: CD 3A 10    call    init_big_alien_103a
0D65: DD 21 90 E1 ld      ix,pickup_obj_e190
0D69: FD 21 5C EF ld      iy,spriteram_shadow_ef00+0x5C     ; s23.code
0D6D: DD 36 00 FF ld      (ix+$00),$FF                    ; active
0D71: DD 36 05 00 ld      (ix+$05),0
0D75: FD 36 02 78 ld      (iy+$02),120                     ; 23.y
0D79: FD 36 03 40 ld      (iy+$03),64                      ; s23.x
0D7D: FD 36 00 2D ld      (iy+$00),$2D ; '-'              ; s23.code='POW'
0D81: 21 25 E0    ld      hl,timer_e025
0D84: 36 78       ld      (hl),120                      ; init timer_e025
0D86: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_1_fn_14__big_alien_instruct_collect_pow_0d89:                  ; ...
0D89: 21 03 EF    ld      hl,spriteram_shadow_ef00+3        ; s0.x
0D8C: 3A 90 E1    ld      a,(pickup_obj_e190)
0D8F: A7          and     a                               ; inactive?
0D90: 28 0E       jr      Z,loc_0da0                      ; yes,go
0D92: 34          inc     (hl)                            ; move ship up
0D93: DD 21 90 E1 ld      ix,pickup_obj_e190
0D97: FD 21 5C EF ld      iy,spriteram_shadow_ef00+0x5C     ; s23.code
0D9B: CD 30 36    call    handle_pickup_3630
0D9E: 18 06       jr      loc_0da6
; ---------------------------------------------------------------------------

loc_0da0:                                                        ; ...
0DA0: 7E          ld      a,(hl)                         ; s0.x
0DA1: FE 11       cp      17                             ; finished up?
0DA3: 38 01       jr      C,loc_0da6                      ; no,skip
0DA5: 35          dec     (hl)                            ; move ship down

loc_0da6:                                                        ; ...
0DA6: DD 21 00 E2 ld      ix,e200_obj_tbl_e200               ; 'viking'
0DAA: FD 21 20 EF ld      iy,spriteram_shadow_ef00+0x20     ; s8.code
0DAE: CD EE 39    call    animate_big_alien_39ee
0DB1: DD 21 20 E2 ld      ix,e200_obj_tbl_e200+0x20         ; 'fly'
0DB5: FD 21 28 EF ld      iy,spriteram_shadow_ef00+0x28     ; s10.code
0DB9: CD EE 39    call    animate_big_alien_39ee
0DBC: DD 21 40 E2 ld      ix,e200_obj_tbl_e200+0x40         ; 'bat'
0DC0: FD 21 30 EF ld      iy,spriteram_shadow_ef00+0x30     ; s12.code
0DC4: CD EE 39    call    animate_big_alien_39ee
0DC7: 21 25 E0    ld      hl,timer_e025
0DCA: 35          dec     (hl)                            ; expired?
0DCB: C0          ret     NZ                              ; no,exit
0DCC: 3E 18       ld      a,24
0DCE: 32 25 E0    ld      (timer_e025),a                      ; re-init timer_e025
0DD1: CD 0B 1E    call    start_bomb_1e0b
0DD4: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_1_fn_15__big_alien_instruct_fire_bomb_0dd7:                    ; ...
0DD7: CD 4B 1E    call    update_bomb_1e4b
0DDA: DD 21 00 E2 ld      ix,e200_obj_tbl_e200               ; 'viking'
0DDE: FD 21 20 EF ld      iy,spriteram_shadow_ef00+0x20     ; s8.code
0DE2: CD EE 39    call    animate_big_alien_39ee
0DE5: DD 21 20 E2 ld      ix,e200_obj_tbl_e200+0x20         ; 'fly'
0DE9: FD 21 28 EF ld      iy,spriteram_shadow_ef00+0x28     ; s10.code
0DED: CD EE 39    call    animate_big_alien_39ee
0DF0: DD 21 40 E2 ld      ix,e200_obj_tbl_e200+0x40         ; 'bat'
0DF4: FD 21 30 EF ld      iy,spriteram_shadow_ef00+0x30     ; s12.code
0DF8: CD EE 39    call    animate_big_alien_39ee
0DFB: 21 25 E0    ld      hl,timer_e025
0DFE: 35          dec     (hl)                            ; expired?
0DFF: C0          ret     NZ                              ; no,exit
0E00: AF          xor     a
0E01: 32 06 EF    ld      (spriteram_shadow_ef00+6),a         ; s1.y (hide bomb)
0E04: CD 58 47    call    stop_bomb_snd_4758
0E07: DD 21 20 E2 ld      ix,e200_obj_tbl_e200+0x20         ; 'fly'
0E0B: FD 21 28 EF ld      iy,spriteram_shadow_ef00+0x28     ; s10.code
0E0F: DD 36 00 01 ld      (ix+$00),1                       ; obj state=1 (about to explode?)
0E13: DD 36 01 00 ld      (ix+$01),0                       ; obj counter
0E17: DD 36 02 00 ld      (ix+$02),0                       ; obj hit count
0E1B: CD 8D 47    call    snd_cmd_02_478d
0E1E: CD EE 39    call    animate_big_alien_39ee
0E21: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_1_fn_16__big_alien_instruct_explode_fly_0e24:                  ; ...
0E24: DD 21 00 E2 ld      ix,e200_obj_tbl_e200               ; 'viking'
0E28: FD 21 20 EF ld      iy,spriteram_shadow_ef00+0x20     ; s8
0E2C: CD EE 39    call    animate_big_alien_39ee
0E2F: DD 21 20 E2 ld      ix,e200_obj_tbl_e200+0x20         ; 'fly'
0E33: FD 21 28 EF ld      iy,spriteram_shadow_ef00+0x28     ; s10
0E37: DD 7E 00    ld      a,(ix+$00)                        ; obj state
0E3A: CD B9 3A    call    check_large_alien_hit_3ab9
0E3D: DD 7E 00    ld      a,(ix+$00)                        ; obj state
0E40: A7          and     a                               ; done exploding?
0E41: CA D6 0F    jp      Z,next_vbl_lvl_1_fn_0fd6            ; yes,go
0E44: DD 21 40 E2 ld      ix,e200_obj_tbl_e200+0x40         ; 'bat'
0E48: FD 21 30 EF ld      iy,spriteram_shadow_ef00+0x30     ; s12
0E4C: CD EE 39    call    animate_big_alien_39ee
0E4F: C9          ret
; ---------------------------------------------------------------------------

vbl_0_1_fn_17__big_alien_instruct_move_left_0e50:                    ; ...
0E50: DD 21 00 E2 ld      ix,e200_obj_tbl_e200               ; 'viking'
0E54: DD 36 02 00 ld      (ix+$02),0                       ; obj hit count
0E58: FD 21 20 EF ld      iy,spriteram_shadow_ef00+0x20     ; s8
0E5C: CD EE 39    call    animate_big_alien_39ee
0E5F: DD 21 40 E2 ld      ix,e200_obj_tbl_e200+0x40         ; 'bat'
0E63: FD 21 30 EF ld      iy,spriteram_shadow_ef00+0x30     ; s12
0E67: CD EE 39    call    animate_big_alien_39ee
0E6A: 21 02 EF    ld      hl,spriteram_shadow_ef00+2        ; s0.y
0E6D: 35          dec     (hl)                            ; move left
0E6E: 7E          ld      a,(hl)                         ; get y
0E6F: FE 49       cp      73                             ; done?
0E71: D0          ret     NC                              ; no,exit
0E72: 3E FF       ld      a,$FF
0E74: 32 00 E2    ld      (e200_obj_tbl_e200),a               ; obj state=active (viking)
0E77: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_1_fn_18__big_alien_instruct_shoot_viking_0e7a:                 ; ...
0E7A: 3A 00 E0    ld      a,(vblank_tick_e000)
0E7D: E6 0F       and     $F                            ; time to fire?
0E7F: CC 5F 1D    call    Z,handle_firing_1d5f                ; yes,go
0E82: CD D6 43    call    check_objs_hit_43d6
0E85: CD A5 1C    call    update_sprite_bullets_1ca5
0E88: DD 21 00 E2 ld      ix,e200_obj_tbl_e200               ; 'viking'
0E8C: FD 21 20 EF ld      iy,spriteram_shadow_ef00+0x20     ; s8
0E90: DD 7E 00    ld      a,(ix+$00)                        ; obj state
0E93: 3C          inc     a                               ; active?
0E94: 28 12       jr      Z,loc_0ea8                      ; yes,go
0E96: DD 34 02    inc     (ix+$02)                           ; hit count
0E99: DD 7E 02    ld      a,(ix+$02)
0E9C: FE 06       cp      6                              ; hit 6 times?
0E9E: D2 B7 0E    jp      NC,big_alien_instruct_viking_destroyed_0eb7 ; yes,go
0EA1: CD 7D 47    call    snd_cmd_03_477d
0EA4: DD 36 00 FF ld      (ix+$00),$FF                    ; activate object

loc_0ea8:                                                        ; ...
0EA8: CD EE 39    call    animate_big_alien_39ee
0EAB: DD 21 40 E2 ld      ix,e200_obj_tbl_e200+0x40         ; 'bat'
0EAF: FD 21 30 EF ld      iy,spriteram_shadow_ef00+0x30     ; s12.code
0EB3: CD EE 39    call    animate_big_alien_39ee
0EB6: C9          ret
; ---------------------------------------------------------------------------

big_alien_instruct_viking_destroyed_0eb7:                            ; ...
0EB7: CD 8D 47    call    snd_cmd_02_478d
0EBA: DD 36 00 01 ld      (ix+$00),1                       ; obj state
0EBE: DD 36 01 00 ld      (ix+$01),0
0EC2: DD 36 02 00 ld      (ix+$02),0                       ; obj hit cont
0EC6: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------
0EC9: C9          ret
; ---------------------------------------------------------------------------

vbl_0_1_fn_19__big_alien_instruct_explode_viking_0eca:               ; ...
0ECA: CD A5 1C    call    update_sprite_bullets_1ca5
0ECD: DD 21 00 E2 ld      ix,e200_obj_tbl_e200               ; 'viking'
0ED1: FD 21 20 EF ld      iy,spriteram_shadow_ef00+0x20     ; s8.code
0ED5: CD B9 3A    call    check_large_alien_hit_3ab9
0ED8: DD 7E 00    ld      a,(ix+$00)                        ; obj state
0EDB: A7          and     a                               ; inactive?
0EDC: CA D6 0F    jp      Z,next_vbl_lvl_1_fn_0fd6            ; yes,go
0EDF: DD 21 40 E2 ld      ix,e200_obj_tbl_e200+0x40         ; 'bat'
0EE3: FD 21 30 EF ld      iy,spriteram_shadow_ef00+0x30     ; s12.code
0EE7: CD EE 39    call    animate_big_alien_39ee
0EEA: 21 25 E0    ld      hl,timer_e025
0EED: 36 60       ld      (hl),$60 ; '`'               ; init timer_e025
0EEF: C9          ret
; ---------------------------------------------------------------------------

vbl_0_1_fn_20__big_alien_instruct_move_to_bat_0ef0:                  ; ...
0EF0: FD 21 00 EF ld      iy,spriteram_shadow_ef00           ; s0
0EF4: FD 34 02    inc     (iy+$02)                           ; move right
0EF7: FD 34 03    inc     (iy+$03)                           ; move up
0EFA: DD 21 40 E2 ld      ix,e200_obj_tbl_e200+0x40         ; 'bat'
0EFE: FD 21 30 EF ld      iy,spriteram_shadow_ef00+0x30     ; s12.code
0F02: CD EE 39    call    animate_big_alien_39ee
0F05: 21 25 E0    ld      hl,timer_e025
0F08: 35          dec     (hl)                            ; expired?
0F09: C0          ret     NZ                              ; no,exit
0F0A: DD 36 00 01 ld      (ix+$00),1                       ; obj state
0F0E: DD 36 01 00 ld      (ix+$01),0
0F12: DD 36 02 00 ld      (ix+$02),0                       ; obj hit count
0F16: 3E 3F       ld      a,$3F ; '?'
0F18: 32 00 E1    ld      (ship_obj_e100),a                   ; flag ship explode
0F1B: 21 25 E0    ld      hl,timer_e025
0F1E: 36 00       ld      (hl),0
0F20: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------
0F23: C9          ret
; ---------------------------------------------------------------------------

vbl_0_1_fn_21__big_alien_instruct_explode_bat_0f24:                  ; ...
0F24: 21 25 E0    ld      hl,timer_e025
0F27: 35          dec     (hl)                            ; expired?
0F28: CA 5C 0F    jp      Z,loc_0f5c                      ; yes,go
0F2B: DD 21 40 E2 ld      ix,e200_obj_tbl_e200+0x40         ; 'bat'
0F2F: FD 21 30 EF ld      iy,spriteram_shadow_ef00+0x30     ; s12.code
0F33: DD 7E 00    ld      a,(ix+$00)                        ; obj state
0F36: A7          and     a                               ; inactive?
0F37: C4 B9 3A    call    NZ,check_large_alien_hit_3ab9       ; no,go
0F3A: 3A 00 E1    ld      a,(ship_obj_e100)
0F3D: A7          and     a                               ; active?
0F3E: C8          ret     Z                               ; no,return
0F3F: CD BC 1A    call    move_ship_1abc
0F42: 3A 00 E1    ld      a,(ship_obj_e100)
0F45: A7          and     a                               ; active?
0F46: C0          ret     NZ                              ; yes,return
0F47: 32 00 E1    ld      (ship_obj_e100),a
0F4A: 32 02 EF    ld      (spriteram_shadow_ef00+2),a         ; s0.y
0F4D: 32 06 EF    ld      (spriteram_shadow_ef00+6),a         ; s1.y
0F50: 32 01 EF    ld      (spriteram_shadow_ef00+1),a         ; s0.colour
0F53: 32 05 EF    ld      (spriteram_shadow_ef00+5),a         ; s1.colour
0F56: 3E 1E       ld      a,30                          ; init
0F58: 32 25 E0    ld      (timer_e025),a
0F5B: C9          ret
; ---------------------------------------------------------------------------

loc_0f5c:                                                        ; ...
0F5C: 3E 24       ld      a,36                          ; init
0F5E: 32 25 E0    ld      (timer_e025),a
0F61: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_1_fn_22__end_instructions_0f64:                                ; ...
0F64: 21 25 E0    ld      hl,timer_e025
0F67: 35          dec     (hl)                            ; expired?
0F68: 20 09       jr      NZ,scroll_background_0f73           ; no,skip
0F6A: CD A1 02    call    hide_all_sprites_02a1
0F6D: 3E 00       ld      a,0
0F6F: 32 06 E0    ld      (vbl_lvl_1_fn_e006),a
0F72: C9          ret
; ---------------------------------------------------------------------------

scroll_background_0f73:                                              ; ...
0F73: 2A 46 E0    ld      hl,(scroll_plus1_shadow_e046)
0F76: 23          inc     hl
0F77: 22 46 E0    ld      (scroll_plus1_shadow_e046),hl
0F7A: C9          ret
; ---------------------------------------------------------------------------

vbl_0_2_fn_0__cls_print_push_start_0f7b:                             ; ...
0F7B: CD B8 40    call    clear_bg_via_renderer_40b8
0F7E: CD A1 02    call    hide_all_sprites_02a1
0F81: CD DE 0B    call    zero_object_data_0bde
0F84: 16 07       ld      d,7                           ; cls
0F86: FF          rst     add_fn_to_q_0038
0F87: 11 07 00    ld      de,7                          ; print PUSH START BUTTON
0F8A: FF          rst     add_fn_to_q_0038
0F8B: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_2_fn_1__render_attract_mode_text_0f8e:                         ; ...
0F8E: CD A6 40    call    inc_bg_prerender_buffer_40a6
0F91: C0          ret     NZ
0F92: 11 00 0F    ld      de,$F00                      ; show attract mode title
0F95: FF          rst     add_fn_to_q_0038
0F96: 3A 22 E0    ld      a,(credits_e022)
0F99: FE 02       cp      2
0F9B: D2 AD 0F    jp      NC,goto_fn_3_tbl_0fad
0F9E: 11 08 00    ld      de,8                          ; print ONE PLAYER ONLY
0FA1: FF          rst     add_fn_to_q_0038
0FA2: 11 00 0E    ld      de,$E00                      ; print bonus life scores
0FA5: FF          rst     add_fn_to_q_0038
0FA6: 11 11 00    ld      de,$11                       ; print (c) CAPCOM 1984
0FA9: FF          rst     add_fn_to_q_0038
0FAA: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

goto_fn_3_tbl_0fad:                                                  ; ...
0FAD: 3E 03       ld      a,3
0FAF: 32 06 E0    ld      (vbl_lvl_1_fn_e006),a
0FB2: C9          ret
; ---------------------------------------------------------------------------

vbl_0_2_fn_2__wait_2_credits_0fb3:                                   ; ...
0FB3: 3A 22 E0    ld      a,(credits_e022)
0FB6: FE 02       cp      2
0FB8: D2 D6 0F    jp      NC,next_vbl_lvl_1_fn_0fd6
0FBB: C9          ret
; ---------------------------------------------------------------------------

vbl_0_2_fn_3__show_lives_bonus_title_0fbc:                           ; ...
0FBC: 11 09 00    ld      de,9                          ; show lives ships
0FBF: FF          rst     add_fn_to_q_0038
0FC0: 11 00 0E    ld      de,$E00                      ; prnt bonus life scores
0FC3: FF          rst     add_fn_to_q_0038
0FC4: 11 00 0F    ld      de,$F00                      ; show attract mode title
0FC7: FF          rst     add_fn_to_q_0038
0FC8: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

locret_0fcb:                                                     ; ...
0FCB: C9          ret
; ---------------------------------------------------------------------------
; schedules the next level 0 function

vbl_inc_lvl_0_reset_lvl_1_fns_0fcc:                                  ; ...
0FCC: 21 06 E0    ld      hl,vbl_lvl_1_fn_e006
0FCF: 36 00       ld      (hl),0
0FD1: 21 05 E0    ld      hl,vbl_lvl_0_fn_e005
0FD4: 34          inc     (hl)
0FD5: C9          ret
; ---------------------------------------------------------------------------
; schedules the next level 1 function

next_vbl_lvl_1_fn_0fd6:                                              ; ...
0FD6: 21 06 E0    ld      hl,vbl_lvl_1_fn_e006
0FD9: 34          inc     (hl)                            ; next fn
0FDA: C9          ret
; End of function init_combo_bonus_sequence_0cf5


; =============== S U B R O U T I N E =======================================


init_objs_at_e200_from_tbl_0fdb:                                     ; ...
0FDB: D9          exx
0FDC: DD 21 00 E2 ld      ix,e200_obj_tbl_e200               ; live object data
0FE0: FD 21 20 EF ld      iy,spriteram_shadow_ef00+0x20     ; s4.code
0FE4: 11 10 00    ld      de,16                         ; data bytes per object
0FE7: 01 04 00    ld      bc,4                          ; bytes per sprite
0FEA: D9          exx
0FEB: 7E          ld      a,(hl)                         ; 1st entry in table
0FEC: 47          ld      b,a                            ;  objects to init
0FED: 32 C7 E0    ld      (formation_cnt_e0c7),a              ; save
0FF0: 23          inc     hl

loc_0ff1:                                                        ; ...
0FF1: 7E          ld      a,(hl)                         ; 1st byte for object
0FF2: 23          inc     hl
0FF3: DD 77 0B    ld      (ix+$0B),a
0FF6: 3E 05       ld      a,5
0FF8: 86          add     a,(hl)                         ; 2nd byte for object
0FF9: 23          inc     hl
0FFA: DD 77 05    ld      (ix+$05),a                        ; obj type=5+(byte)
0FFD: 7E          ld      a,(hl)                         ; 3rd byte for object
0FFE: 23          inc     hl
0FFF: DD 77 0D    ld      (ix+$0D),a
1002: 7E          ld      a,(hl)                         ; 4th byte for object
1003: 23          inc     hl
1004: FD 77 02    ld      (iy+$02),a                        ; sprite y
1007: 7E          ld      a,(hl)                         ; 5th byte for object
1008: 23          inc     hl
1009: FD 77 03    ld      (iy+$03),a                        ; sprite x
100C: FD 36 00 FF ld      (iy+$00),$FF                    ; sprite code (blank)
1010: FD 36 01 00 ld      (iy+$01),0                       ; sprite colour
1014: DD 36 00 FE ld      (ix+$00),$FE ; '�'              ; obj state=spawning?
1018: AF          xor     a
1019: DD 77 0C    ld      (ix+$0C),a
101C: DD 77 02    ld      (ix+$02),a                        ; obj timer_e025
101F: DD 77 03    ld      (ix+$03),a                        ; obj y lsb
1022: DD 77 04    ld      (ix+$04),a                        ; obj x lsb
1025: DD 36 0F 08 ld      (ix+$0f),8                     ; obj aiming entry
1029: DD 36 0A 05 ld      (ix+$0a),5                     ; dy_dx lookup tbl index
102D: D9          exx
102E: DD 19       add     ix,de                          ; next object data
1030: FD 09       add     iy,bc                          ; next sprite
1032: D9          exx
1033: 79          ld      a,c                            ; *** UNUSED???
1034: C6 10       add     a,$10
1036: 4F          ld      c,a
1037: 10 B8       djnz    loc_0ff1
1039: C9          ret
; End of function init_objs_at_e200_from_tbl_0fdb


; =============== S U B R O U T I N E =======================================


init_big_alien_103a:                                                 ; ...
103A: FD 70 02    ld      (iy+$02),b                        ; sn.y
103D: FD 36 03 80 ld      (iy+$03),128                     ; sn.x
1041: FD 36 01 40 ld      (iy+$01),$40 ; '@'              ; sn.colour
1045: FD 36 05 40 ld      (iy+$05),$40 ; '@'              ; s(n+1).colour
1049: DD 36 00 00 ld      (ix+$00),0                       ; state=inactive
104D: DD 77 05    ld      (ix+$05),a                        ; type
1050: CD EB 37    call    update_2nd_sprite_37eb
1053: CD EE 39    call    animate_big_alien_39ee
1056: C9          ret
; End of function init_big_alien_103a

; ---------------------------------------------------------------------------

vbl_0_fn_3__handle_game_1057:                                        ; ...
1057: 3A 06 E0    ld      a,(vbl_lvl_1_fn_e006)
105A: F7          rst    $30		  ; [jump_to_jump_table] [nb_entries=11]
; ---------------------------------------------------------------------------
	.word vbl_0_3_fn_0__init_and_wipe_1up_2up_1102
	.word vbl_0_3_fn_1__switch_to_next_player_1132
	.word vbl_0_3_fn_2__init_bullets_and_ship_sprite_117c
	.word vbl_0_3_fn_3__ready_11a1
	.word vbl_0_3_fn_4__gameplay_11dd
	.word vbl_0_3_fn_5__game_over_12c8
	.word vbl_0_3_fn_6__render_bg_lines_12de
	.word vbl_0_3_fn_7__check_insert_hi_score_12e5
	.word vbl_0_3_fn_8__init_hi_score_entry_12fb
	.word vbl_0_3_fn_9__hi_score_entry_1308
	.word vbl_0_3_fn_10__delay_1332

; =============== S U B R O U T I N E =======================================


clear_all_player_sprite_bullets_1071:                                ; ...
1071: FD 21 12 EF ld      iy,spriteram_shadow_ef00+0x12     ; set s4.y as base
1075: FD 36 00 00 ld      (iy+$00),0                       ; s4.y
1079: FD 36 04 00 ld      (iy+$04),0                       ; s5.y
107D: FD 36 08 00 ld      (iy+$08),0                       ; s6.y
1081: FD 36 0C 00 ld      (iy+$0c),0                      ; s7.y
1085: DD 21 10 E1 ld      ix,bullet_obj_tbl_e110
1089: DD 36 00 00 ld      (ix+$00),0                       ; obj0 state=inactive
108D: DD 36 10 00 ld      (ix+$10),0                    ; obj1 state=inactive
1091: DD 36 20 00 ld      (ix+$20),0                    ; obj2 state=inactive
1095: DD 36 30 00 ld      (ix+$30),0                    ; obj3 state=inactive
1099: C9          ret
; End of function clear_all_player_sprite_bullets_1071


; =============== S U B R O U T I N E =======================================


init_p1_p2_data_109a:                                                ; ...
109A: AF          xor     a
109B: 32 01 EC    ld      (curr_player_ec01),a
109E: 32 07 E0    ld      (curr_controls_e007),a
10A1: 21 5E D0    ld      hl,fgvideoram_code_d000+0x5E
10A4: 06 08       ld      b,8                           ; 8 chars to clear
10A6: 11 20 00    ld      de,$20 ; ' '                 ; column offset

loc_10a9:                                                       ; ...
10A9: 36 20       ld      (hl),$20 ; ' '	; [video_address]
10AB: 19          add     hl,de                          ; next column
10AC: 10 FB       djnz    loc_10a9
10AE: 21 DE D2    ld      hl,fgvideoram_code_d000+0x2DE
10B1: 06 08       ld      b,8                           ; 8 chars to clear

loc_10b3:                                                       ; ...
10B3: 36 20       ld      (hl),$20 ; ' '         	; [video_address]      ; column offset
10B5: 19          add     hl,de                          ; next column
10B6: 10 FB       djnz    loc_10b3
10B8: 21 20 E5    ld      hl,p1_lives_left_e520
10BB: 3A 1C E0    ld      a,(start_lives_e01c)
10BE: 77          ld      (hl),a                         ; init current lives
10BF: 2C          inc     l
10C0: 36 00       ld      (hl),0
10C2: 2C          inc     l
10C3: 36 00       ld      (hl),0                        ; init map_planet_e502
10C5: 2C          inc     l
10C6: 36 04       ld      (hl),4                        ; init map_area_e503
10C8: 2C          inc     l
10C9: 3A 1A E0    ld      a,(bonus_life_1st_e01a)
10CC: 77          ld      (hl),a
10CD: 2C          inc     l
10CE: 3A 1B E0    ld      a,(bonus_life_2nd_e01b)
10D1: 77          ld      (hl),a
10D2: 2C          inc     l
10D3: 36 06       ld      (hl),6                        ; init curr_num_bombs_e506
10D5: 2C          inc     l
10D6: 36 15       ld      (hl),$15                     ; init jap symbol appearance score =150,000
10D8: 2C          inc     l
10D9: 36 00       ld      (hl),0                        ; bomb_fired???
10DB: 21 41 EE    ld      hl,p1_score_ee41
10DE: 36 00       ld      (hl),0
10E0: 2C          inc     l
10E1: 36 00       ld      (hl),0
10E3: 2C          inc     l
10E4: 36 00       ld      (hl),0                        ; init port_1_c001 score
10E6: 3A 00 EC    ld      a,(two_p_game_ec00)
10E9: A7          and     a                               ; 2P?
10EA: C8          ret     Z                               ; no,exit
10EB: 11 40 E5    ld      de,p2_lives_left_e540
10EE: 21 20 E5    ld      hl,p1_lives_left_e520
10F1: 01 10 00    ld      bc,$10
10F4: ED B0       ldir                                    ; init p2_e003 data
10F6: 21 44 EE    ld      hl,p2_score_ee44
10F9: 36 00       ld      (hl),0
10FB: 2C          inc     l
10FC: 36 00       ld      (hl),0
10FE: 2C          inc     l
10FF: 36 00       ld      (hl),0                        ; init p2_e003 score
1101: C9          ret
; End of function init_p1_p2_data_109a

; ---------------------------------------------------------------------------

vbl_0_3_fn_0__init_and_wipe_1up_2up_1102:                            ; ...
1102: 11 03 01    ld      de,$103                      ; print CREDIT
1105: FF          rst     add_fn_to_q_0038
1106: CD 7B 2A    call    init_rand_2a7b
1109: CD 9A 10    call    init_p1_p2_data_109a
110C: 11 00 0A    ld      de,$A00                      ; scroll left 18 rows
110F: FF          rst     add_fn_to_q_0038
1110: 11 00 02    ld      de,$200                      ; print curr score
1113: FF          rst     add_fn_to_q_0038
1114: 3A 00 EC    ld      a,(two_p_game_ec00)
1117: A7          and     a                               ; 2P?
1118: C2 22 11    jp      NZ,loc_1122                    ; yes,skip
111B: 11 01 01    ld      de,$101                      ; wipe 2UP
111E: FF          rst     add_fn_to_q_0038
111F: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

loc_1122:                                                       ; ...
1122: 11 01 00    ld      de,1                          ; wipe 1UP
1125: FF          rst     add_fn_to_q_0038
1126: 21 BE D3    ld      hl,fgvideoram_code_d000+0x3BE
1129: 36 30       ld      (hl),$30 ; '0'               ; code
112B: CB D4       set     2,h                            ; ptr colour
112D: 36 09       ld      (hl),9                        ; colour
112F: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_3_fn_1__switch_to_next_player_1132:                            ; ...
1132: AF          xor     a
1133: 32 07 E0    ld      (curr_controls_e007),a
1136: 21 20 E5    ld      hl,p1_lives_left_e520
1139: 11 40 E5    ld      de,p2_lives_left_e540
113C: 3A 01 EC    ld      a,(curr_player_ec01)
113F: A7          and     a                               ; p1_e002?
1140: 28 06       jr      Z,loc_1148                     ; yes,skip
1142: 21 40 E5    ld      hl,p2_lives_left_e540
1145: 11 20 E5    ld      de,p1_lives_left_e520

loc_1148:                                                       ; ...
1148: 7E          ld      a,(hl)
1149: A7          and     a                               ; any lives left?
114A: 20 0A       jr      NZ,loc_1156                    ; yes,skip
114C: EB          ex      de,hl
114D: 3A 01 EC    ld      a,(curr_player_ec01)
1150: 3C          inc     a                               ; switch curr player
1151: E6 01       and     1
1153: 32 01 EC    ld      (curr_player_ec01),a                ; update

loc_1156:                                                       ; ...
1156: 11 00 E5    ld      de,curr_lives_left_e500
1159: 01 10 00    ld      bc,16
115C: ED B0       ldir                                    ; copy to curr player state
115E: 11 00 09    ld      de,$900                      ; show lives ships
1161: FF          rst     add_fn_to_q_0038
1162: CD DC 47    call    init_curr_player_map_data_47dc
1165: 3A 01 EC    ld      a,(curr_player_ec01)
1168: E6 01       and     1                              ; p1_e002?
116A: CA D6 0F    jp      Z,next_vbl_lvl_1_fn_0fd6            ; yes,skip
116D: 3A 1D E0    ld      a,(cabinet_e01d)
1170: A7          and     a                               ; cocktail?
1171: CA D6 0F    jp      Z,next_vbl_lvl_1_fn_0fd6            ; no,skip
1174: 3E 01       ld      a,1                           ; flag alternate controls
1176: 32 07 E0    ld      (curr_controls_e007),a
1179: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_3_fn_2__init_bullets_and_ship_sprite_117c:                     ; ...
117C: CD 6D 47    call    play_snd_128_476d
117F: CD 98 48    call    build_bg_prerender_and_test_4898
1182: C0          ret     NZ
1183: CD 7D 1C    call    init_bullet_and_bomb_objs_1c7d
1186: CD 97 1A    call    init_player_sprite_1a97
1189: 11 18 00    ld      de,$18                       ; print PLAYER 1
118C: 3A 01 EC    ld      a,(curr_player_ec01)
118F: E6 01       and     1
1191: 28 01       jr      Z,loc_1194
1193: 1C          inc     e                               ; print PLAYER 2

loc_1194:                                                       ; ...
1194: FF          rst     add_fn_to_q_0038
1195: 11 1A 00    ld      de,$1A                       ; print READY
1198: FF          rst     add_fn_to_q_0038
1199: 3E 3C       ld      a,$3C ; '<'
119B: 32 25 E0    ld      (timer_e025),a                      ; init timer_e025
119E: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_3_fn_3__ready_11a1:                                            ; ...
11A1: CD BC 1A    call    move_ship_1abc
11A4: CD 9B 1C    call    handle_firing_bullets_and_upd_bombs_1c9b ; NOTE: uses sprite bullets!
11A7: CD F4 49    call    sub_49f4                        ; * map stuff
11AA: 21 25 E0    ld      hl,timer_e025
11AD: 35          dec     (hl)                            ; expired?
11AE: C0          ret     NZ                              ; no,exit
11AF: 11 1A 01    ld      de,$11A                      ; print READY
11B2: FF          rst     add_fn_to_q_0038
11B3: 11 18 01    ld      de,$118                      ; print PLAYER 1
11B6: FF          rst     add_fn_to_q_0038
11B7: CD 71 10    call    clear_all_player_sprite_bullets_1071
11BA: CD 2C 2B    call    reset_some_stuff_2b2c
11BD: AF          xor     a
11BE: 32 C8 E0    ld      (formations_destroyed_cnt_e0c8),a
11C1: 32 1F E0    ld      (byte_e01f),a
11C4: 32 9D E0    ld      (spawn_jap_symb_flag_e09d),a        ; init japanese symbol flag
11C7: 3A 06 E5    ld      a,(curr_num_bombs_e506)
11CA: FE 04       cp      4                              ; more than 4?
11CC: 30 09       jr      NC,loc_11d7                    ; no,skip
11CE: 3E 04       ld      a,4                           ; reset to 4
11D0: 32 06 E5    ld      (curr_num_bombs_e506),a
11D3: 11 00 0D    ld      de,$D00                      ; show bombs
11D6: FF          rst     add_fn_to_q_0038

loc_11d7:                                                       ; ...
11D7: CD 46 2B    call    init_planet_area_data_2b46
11DA: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_3_fn_4__gameplay_11dd:                                         ; ...
11DD: CD 1E 6A    call    update_aiming_table_6a1e
11E0: CD EB 2B    call    tick_timers_2beb
11E3: CD 3B 2C    call    spawn_e200_objects_2c3b
11E6: CD BC 1A    call    move_ship_1abc
11E9: CD F4 49    call    sub_49f4                        ; map stuff
11EC: CD 12 1D    call    update_player_bullets_and_bombs_1d12
11EF: CD C0 3B    call    spawn_e300_objects_3bc0
11F2: CD C2 3D    call    update_e300_objects_3dc2
11F5: CD 22 37    call    spawn_large_alien_3722
11F8: CD A4 37    call    update_large_aliens_37a4             ; also fires
11FB: CD BE 20    call    update_e200_objects_20be             ; also fires
11FE: CD 99 29    call    update_alien_bullets_2999
1201: CD 94 34    call    update_pickup_3494
1204: CD D6 43    call    check_objs_hit_43d6
1207: CD AF 12    call    flash_1up_2up_12af
120A: 3A 00 E1    ld      a,(ship_obj_e100)
120D: A7          and     a                               ; inactive?
120E: C0          ret     NZ                              ; no,exit
; player has died
120F: 3A 03 E5    ld      a,(map_area_e503)

; =============== S U B R O U T I N E =======================================


sub_1212:
1212: FE 10       cp      16                             ; greater than 15?
1214: 38 05       jr      C,loc_121b                     ; no,skip
1216: 3E 0F       ld      a,15                          ; max=15
1218: 32 03 E5    ld      (map_area_e503),a                   ; update

loc_121b:                                                       ; ...
121B: 3A 1F E0    ld      a,(byte_e01f)
121E: A7          and     a
121F: 28 13       jr      Z,loc_1234
1221: 3C          inc     a
1222: 28 10       jr      Z,loc_1234
1224: 21 01 E5    ld      hl,byte_e501
1227: 34          inc     (hl)
; next planet
1228: 2C          inc     l                               ; ptr map_planet_e502
1229: 34          inc     (hl)                            ; next planet
122A: 7E          ld      a,(hl)
122B: FE 09       cp      9                              ; max?
122D: 38 02       jr      C,loc_1231                     ; no,skip
122F: 36 00       ld      (hl),0                        ; reset planet

loc_1231:                                                       ; ...
1231: 2C          inc     l                               ; ptr map_area_e503
1232: 36 00       ld      (hl),0                        ; reset area

loc_1234:                                                       ; ...
1234: 11 00 00    ld      de,0                          ; print 1UP
1237: 3A 01 EC    ld      a,(curr_player_ec01)
123A: A7          and     a                               ; p1_e002?
123B: 28 01       jr      Z,dec_lives_123e                    ; yes,skip
123D: 1C          inc     e                               ; print 2UP

dec_lives_123e:                                                      ; ...
123E: FF          rst     add_fn_to_q_0038
123F: CD A1 02    call    hide_all_sprites_02a1
1242: CD DE 0B    call    zero_object_data_0bde
1245: 21 00 E5    ld      hl,curr_lives_left_e500
1248: 35          dec     (hl)                            ; lose a life
1249: C2 71 12    jp      NZ,loc_1271                    ; some left,go
124C: 21 20 E5    ld      hl,p1_lives_left_e520
124F: 3A 01 EC    ld      a,(curr_player_ec01)
1252: E6 01       and     1                              ; p1_e002?
1254: 47          ld      b,a
1255: 28 03       jr      Z,game_over_125a                    ; yes,skip
1257: 21 40 E5    ld      hl,p2_lives_left_e540

game_over_125a:                                                      ; ...
125A: 36 00       ld      (hl),0                        ; zero p1_e002/p2_e003 lives left
125C: 78          ld      a,b                            ; p1_e002/p2_e003
125D: C6 18       add     a,$18                        ; print PLAYER 1/2
125F: 5F          ld      e,a
1260: 16 00       ld      d,0                           ; print fn
1262: FF          rst     add_fn_to_q_0038
1263: 1E 1B       ld      e,$1B                        ; print GAME OVER
1265: FF          rst     add_fn_to_q_0038
1266: 3E 78       ld      a,120
1268: 32 25 E0    ld      (timer_e025),a
126B: CD 9D 47    call    snd_cmd_08_479d
126E: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

loc_1271:                                                       ; ...
1271: 11 00 09    ld      de,$900                      ; show lives ships
1274: FF          rst     add_fn_to_q_0038
1275: 3A 00 EC    ld      a,(two_p_game_ec00)
1278: A7          and     a                               ; 1p?
1279: 28 23       jr      Z,save_curr_1p_status_129e          ; yes,go
127B: 3A 01 EC    ld      a,(curr_player_ec01)
127E: A7          and     a                               ; p1_e002?
127F: 11 20 E5    ld      de,p1_lives_left_e520
1282: 28 03       jr      Z,save_curr_2p_status_and_switch_1287 ; yes,skip
1284: 11 40 E5    ld      de,p2_lives_left_e540

save_curr_2p_status_and_switch_1287:                                 ; ...
1287: 21 00 E5    ld      hl,curr_lives_left_e500
128A: 01 10 00    ld      bc,$10
128D: ED B0       ldir                                    ; save current status to p1_e002/p2_e003 status
128F: 3A 01 EC    ld      a,(curr_player_ec01)
1292: 3C          inc     a                               ; switch curr player
1293: E6 01       and     1
1295: 32 01 EC    ld      (curr_player_ec01),a                ; update
1298: 3E 01       ld      a,1                           ; restart lvl1 fn
129A: 32 06 E0    ld      (vbl_lvl_1_fn_e006),a
129D: C9          ret
; ---------------------------------------------------------------------------

save_curr_1p_status_129e:                                            ; ...
129E: 11 20 E5    ld      de,p1_lives_left_e520
12A1: 21 00 E5    ld      hl,curr_lives_left_e500
12A4: 01 10 00    ld      bc,$10
12A7: ED B0       ldir
12A9: 3E 01       ld      a,1
12AB: 32 06 E0    ld      (vbl_lvl_1_fn_e006),a
12AE: C9          ret
; End of function sub_1212


; =============== S U B R O U T I N E =======================================


flash_1up_2up_12af:                                                  ; ...
12AF: 16 00       ld      d,0                           ; print string param
12B1: 3A 00 E0    ld      a,(vblank_tick_e000)
12B4: 47          ld      b,a
12B5: E6 0F       and     $F                            ; time to flash?
12B7: C0          ret     NZ                              ; no,exit
12B8: 3A 01 EC    ld      a,(curr_player_ec01)
12BB: E6 01       and     1
12BD: 5F          ld      e,a                            ; 1UP/2UP
12BE: 78          ld      a,b                            ; timer_e025
12BF: E6 10       and     $10
12C1: CA 38 00    jp      Z,add_fn_to_q_0038
12C4: 14          inc     d                               ; wipe string param
12C5: C3 38 00    jp      add_fn_to_q_0038
; End of function flash_1up_2up_12af

; ---------------------------------------------------------------------------

vbl_0_3_fn_5__game_over_12c8:                                        ; ...
12C8: CD F4 49    call    sub_49f4                        ; map stuff
12CB: 21 25 E0    ld      hl,timer_e025
12CE: 35          dec     (hl)
12CF: C0          ret     NZ
12D0: 11 1B 01    ld      de,$11B                      ; print GAME OVER
12D3: FF          rst     add_fn_to_q_0038
12D4: 11 18 01    ld      de,$118                      ; print PLAYER 1
12D7: FF          rst     add_fn_to_q_0038
12D8: CD B8 40    call    clear_bg_via_renderer_40b8
12DB: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_3_fn_6__render_bg_lines_12de:                                  ; ...
12DE: CD A6 40    call    inc_bg_prerender_buffer_40a6
12E1: C0          ret     NZ
12E2: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_3_fn_7__check_insert_hi_score_12e5:                            ; ...
12E5: CD 86 14    call    calc_score_rank_1486
12E8: 3A 32 E0    ld      a,(curr_score_rank_e032)
12EB: FE 06       cp      6                              ; in table?
12ED: CA B8 13    jp      Z,check_lives_reset_lvl_1_inc_lvl_0_13b8 ; no,go
12F0: 3E 3C       ld      a,$3C ; '<'
12F2: 32 25 E0    ld      (timer_e025),a
12F5: CD CA 14    call    insert_hi_score_14ca
12F8: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_3_fn_8__init_hi_score_entry_12fb:                              ; ...
12FB: 11 14 00    ld      de,$14                       ; print RANKING TIMER 60
12FE: FF          rst     add_fn_to_q_0038
12FF: 16 04       ld      d,4                           ; print hi score table
1301: FF          rst     add_fn_to_q_0038
1302: CD E6 13    call    init_hi_score_entry_13e6
1305: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_3_fn_9__hi_score_entry_1308:                                   ; ...
1308: CD 3A 13    call    update_ranking_timer_133a
130B: CD 16 14    call    flash_curr_high_score_entry_char_1416
130E: CD 5E 14    call    check_hi_score_entry_left_145e
1311: CD 36 14    call    check_hi_score_entry_right_1436
1314: 3A 0C E0    ld      a,(curr_player_b1_e00c)
1317: FE FF       cp      $FF                           ; held?
1319: 28 08       jr      Z,check_hi_score_entry_b1_1323      ; yes,go
131B: E6 07       and     7                              ; last 3 reads
131D: C8          ret     Z                               ; nothing,return
131E: FE 03       cp      3                              ; 011?
1320: C0          ret     NZ                              ; no,return
1321: 18 08       jr      handle_hi_score_entry_b1_132b
; ---------------------------------------------------------------------------

check_hi_score_entry_b1_1323:                                        ; ...
1323: 21 3F E0    ld      hl,hi_score_b1_repeat_tmr_e03f
1326: 34          inc     (hl)                            ; tick
1327: 7E          ld      a,(hl)
1328: FE 0F       cp      $F                            ; expired?
132A: C0          ret     NZ                              ; no,exit

handle_hi_score_entry_b1_132b:                                       ; ...
132B: CD 63 13    call    hi_score_entry_b1_1363               ; max chars?
132E: C0          ret     NZ                              ; no,exit
132F: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; ---------------------------------------------------------------------------

vbl_0_3_fn_10__delay_1332:                                           ; ...
1332: 21 25 E0    ld      hl,timer_e025
1335: 35          dec     (hl)                            ; expired?
1336: C0          ret     NZ                              ; no,return
1337: C3 B8 13    jp      check_lives_reset_lvl_1_inc_lvl_0_13b8

; =============== S U B R O U T I N E =======================================


update_ranking_timer_133a:                                           ; ...

; FUNCTION CHUNK AT ROM:135E SIZE 00000004 BYTES

133A: 3A 40 E0    ld      a,(ranking_timer_tmr_e040)
133D: A7          and     a
133E: 28 05       jr      Z,ranking_timer_tick_1345
1340: 3D          dec     a
1341: 32 40 E0    ld      (ranking_timer_tmr_e040),a
1344: C9          ret
; ---------------------------------------------------------------------------

ranking_timer_tick_1345:                                             ; ...
1345: 3E 3C       ld      a,60
1347: 32 40 E0    ld      (ranking_timer_tmr_e040),a          ; re-init
134A: 21 41 E0    ld      hl,ranking_timer_value_e041
134D: 7E          ld      a,(hl)
134E: D6 01       sub     1                              ; tick
1350: 27          daa
1351: DA 5E 13    jp      C,ranking_timer_expired_135e        ; exit if expired
1354: 77          ld      (hl),a                         ; update value
; End of function update_ranking_timer_133a


; =============== S U B R O U T I N E =======================================


print_ranking_timer_1355:                                            ; ...
1355: 21 D2 D2    ld      hl,fgvideoram_code_d000+0x2D2     ; ranking timer_e025 value addr
1358: 0E 08       ld      c,8                           ; update colour (red)
135A: C3 BF 41    jp      print_hex_byte_41bf                  ; print value
; End of function print_ranking_timer_1355

; ---------------------------------------------------------------------------
135D: C9          ret
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR update_ranking_timer_133a

ranking_timer_expired_135e:                                          ; ...
135E: E1          pop     hl                              ; discard caller context
135F: C3 D6 0F    jp      next_vbl_lvl_1_fn_0fd6
; END OF FUNCTION CHUNK FOR update_ranking_timer_133a
; ---------------------------------------------------------------------------
1362: C9          ret

; =============== S U B R O U T I N E =======================================


hi_score_entry_b1_1363:                                              ; ...
1363: 2A 38 E0    ld      hl,(hi_score_entry_fgvideoram_addr_e038)
1366: 3A 37 E0    ld      a,(curr_hi_score_entry_char_e037)
1369: FE 3F       cp      $3F ; '?'                     ; END?
136B: CA D6 0F    jp      Z,next_vbl_lvl_1_fn_0fd6            ; yes,go
136E: 77          ld      (hl),a                         ; update code
136F: CB D4       set     2,h                            ; ptr colour
1371: 36 05       ld      (hl),5                        ; update colour (steel blue)
1373: CB 94       res     2,h                            ; ptr code
1375: ED 5B 3B E0 ld      de,(ptr_hi_score_entry_name_e03b)
1379: 12          ld      (de),a                         ; insert char
137A: 13          inc     de                              ; next addr
137B: EB          ex      de,hl
137C: 22 3B E0    ld      (ptr_hi_score_entry_name_e03b),hl   ; update
137F: 21 20 00    ld      hl,$20 ; ' '                 ; column offset
1382: 19          add     hl,de                          ; next char addr
1383: 22 38 E0    ld      (hi_score_entry_fgvideoram_addr_e038),hl ; save
1386: 3E 3F       ld      a,$3F ; '?'                  ; END
1388: 32 37 E0    ld      (curr_hi_score_entry_char_e037),a   ; save
138B: 21 3F E0    ld      hl,hi_score_b1_repeat_tmr_e03f
138E: 36 00       ld      (hl),0                        ; init
1390: 3A 3A E0    ld      a,(num_hi_score_entry_chars_e03a)
1393: 3C          inc     a                               ; inc
1394: 32 3A E0    ld      (num_hi_score_entry_chars_e03a),a
1397: FE 03       cp      3                              ; max?
1399: C9          ret
; End of function hi_score_entry_b1_1363

; ---------------------------------------------------------------------------
; *** UNUSED???
139A: 3A 0C E0    ld      a,(curr_player_b1_e00c)
139D: E6 07       and     7                              ; pressed?
139F: C8          ret     Z                               ; no,exit
13A0: FE 03       cp      3                              ; 011?
13A2: C0          ret     NZ                              ; no,exit
13A3: 11 00 08    ld      de,$800                      ; add to score and update hi (50 pts)
13A6: C3 38 00    jp      add_fn_to_q_0038
; ---------------------------------------------------------------------------
; *** UNUSED???
13A9: 3A 0B E0    ld      a,(curr_player_up_e00b)
13AC: E6 07       and     7                              ; pressed?
13AE: C8          ret     Z                               ; no,exit
13AF: FE 03       cp      3                              ; 011?
13B1: C0          ret     NZ                              ; no,exit
13B2: 11 05 08    ld      de,$805                      ; add to score and update hi (500 pts)
13B5: C3 38 00    jp      add_fn_to_q_0038
; ---------------------------------------------------------------------------

check_lives_reset_lvl_1_inc_lvl_0_13b8:                              ; ...
13B8: 11 00 0A    ld      de,$A00                      ; scroll left 18 rows
13BB: FF          rst     add_fn_to_q_0038
13BC: 3A 00 EC    ld      a,(two_p_game_ec00)
13BF: A7          and     a                               ; 1p?
13C0: 28 11       jr      Z,loc_13d3                     ; yes,go
13C2: 21 40 E5    ld      hl,p2_lives_left_e540
13C5: 3A 01 EC    ld      a,(curr_player_ec01)
13C8: E6 01       and     1                              ; p1_e002?
13CA: 28 03       jr      Z,loc_13cf                     ; yes,skip
13CC: 21 20 E5    ld      hl,p1_lives_left_e520

loc_13cf:                                                       ; ...
13CF: 7E          ld      a,(hl)
13D0: A7          and     a                               ; any lives left?
13D1: 20 0D       jr      NZ,set_vbl_lvl_1_fn_to_1_13e0       ; yes,go

loc_13d3:                                                       ; ...
13D3: 3E 00       ld      a,0
13D5: 32 06 E0    ld      (vbl_lvl_1_fn_e006),a               ; reset vbl lvl_1_fn
13D8: 32 07 E0    ld      (curr_controls_e007),a
13DB: 3C          inc     a                               ; next vbl lvl_0 fn
13DC: 32 05 E0    ld      (vbl_lvl_0_fn_e005),a
13DF: C9          ret
; ---------------------------------------------------------------------------

set_vbl_lvl_1_fn_to_1_13e0:                                          ; ...
13E0: 3E 01       ld      a,1
13E2: 32 06 E0    ld      (vbl_lvl_1_fn_e006),a
13E5: C9          ret

; =============== S U B R O U T I N E =======================================


init_hi_score_entry_13e6:                                            ; ...
13E6: 3E 3F       ld      a,$3F ; '?'                  ; 'END'
13E8: 32 37 E0    ld      (curr_hi_score_entry_char_e037),a   ; init
13EB: 3E 00       ld      a,0
13ED: 32 3A E0    ld      (num_hi_score_entry_chars_e03a),a   ; init
13F0: 3A 32 E0    ld      a,(curr_score_rank_e032)
13F3: 3D          dec     a
13F4: 21 0A 14    ld      hl,hi_score_entry_fgvideoram_addr_tbl_140a
13F7: EF          rst     de_eq_contents_hl_plus_2a_0028       ; get video ram address for entry
13F8: EB          ex      de,hl
13F9: 22 38 E0    ld      (hi_score_entry_fgvideoram_addr_e038),hl ; store
13FC: 3E 3C       ld      a,$3C ; '<'
13FE: 32 40 E0    ld      (ranking_timer_tmr_e040),a          ; init
1401: 3E 60       ld      a,$60 ; '`'
1403: 32 41 E0    ld      (ranking_timer_value_e041),a        ; init
1406: CD 55 13    call    print_ranking_timer_1355
1409: C9          ret
; End of function init_hi_score_entry_13e6

; ---------------------------------------------------------------------------
	.word fgvideoram_code_d000+0x2AD    ; ...
	.word fgvideoram_code_d000+0x2AB
	.word fgvideoram_code_d000+0x2A9
	.word fgvideoram_code_d000+0x2A7
	.word fgvideoram_code_d000+0x2A5
	.word fgvideoram_code_d000+0x2A5

; =============== S U B R O U T I N E =======================================


flash_curr_high_score_entry_char_1416:                               ; ...
1416: 3A 00 E0    ld      a,(vblank_tick_e000)
1419: 47          ld      b,a                            ; save
141A: E6 03       and     3                              ; time to blink?
141C: C0          ret     NZ                              ; no exit
141D: 2A 38 E0    ld      hl,(hi_score_entry_fgvideoram_addr_e038)
1420: CB 50       bit     2,b                            ; grey-blue?
1422: 20 09       jr      NZ,display_char_grey_blue_142d      ; yes,go
1424: 3A 37 E0    ld      a,(curr_hi_score_entry_char_e037)
1427: 77          ld      (hl),a                         ; update code  [unchecked_address]
1428: CB D4       set     2,h                            ; ptr colour
142A: 36 08       ld      (hl),8                        ; red   [video_address]
142C: C9          ret
; ---------------------------------------------------------------------------

display_char_grey_blue_142d:                                         ; ...
142D: 3A 37 E0    ld      a,(curr_hi_score_entry_char_e037)   ; curr hi score entry char
1430: 77          ld      (hl),a                         ; update code  [unchecked_address]
1431: CB D4       set     2,h                            ; ptr colour
1433: 36 03       ld      (hl),3                        ; grey-blue  [video_address]
1435: C9          ret
; End of function flash_curr_high_score_entry_char_1416


; =============== S U B R O U T I N E =======================================


check_hi_score_entry_right_1436:                                     ; ...
1436: 3A 08 E0    ld      a,(curr_player_right_e008)
1439: FE FF       cp      $FF                           ; held?
143B: 28 16       jr      Z,loc_1453                     ; yes,go
143D: E6 07       and     7                              ; last 3 reads
143F: C8          ret     Z                               ; nothing,return
1440: FE 03       cp      3                              ; 011?
1442: C0          ret     NZ                              ; no,return

loc_1443:                                                       ; ...
1443: 3A 37 E0    ld      a,(curr_hi_score_entry_char_e037)
1446: FE 5A       cp      $5A ; 'Z'                     ; 'Z'?
1448: C8          ret     Z                               ; yes,exit
1449: 3C          inc     a                               ; next char
144A: 32 37 E0    ld      (curr_hi_score_entry_char_e037),a
144D: 21 3D E0    ld      hl,hi_score_right_repeat_tmr_e03d
1450: 36 00       ld      (hl),0                        ; init
1452: C9          ret
; ---------------------------------------------------------------------------

loc_1453:                                                       ; ...
1453: 21 3D E0    ld      hl,hi_score_right_repeat_tmr_e03d
1456: 34          inc     (hl)                            ; tick
1457: 7E          ld      a,(hl)
1458: FE 0F       cp      $F                            ; expired?
145A: C0          ret     NZ                              ; no,exit
145B: 18 E6       jr      loc_1443                        ; do repeat
; End of function check_hi_score_entry_right_1436

; ---------------------------------------------------------------------------
145D: C9          ret

; =============== S U B R O U T I N E =======================================


check_hi_score_entry_left_145e:                                      ; ...
145E: 3A 09 E0    ld      a,(curr_player_left_e009)
1461: FE FF       cp      $FF                           ; held?
1463: 28 16       jr      Z,loc_147b                     ; yes,go
1465: E6 07       and     7                              ; last 3 read
1467: C8          ret     Z                               ; nothing,return
1468: FE 03       cp      3                              ; 011?
146A: C0          ret     NZ                              ; no,return

loc_146b:                                                       ; ...
146B: 3A 37 E0    ld      a,(curr_hi_score_entry_char_e037)
146E: FE 3F       cp      $3F ; '?'                     ; END?
1470: C8          ret     Z                               ; yes,exit
1471: 3D          dec     a                               ; previous char
1472: 32 37 E0    ld      (curr_hi_score_entry_char_e037),a   ; store
1475: 21 3E E0    ld      hl,hi_score_left_repeat_tmr_e03e
1478: 36 00       ld      (hl),0                        ; init
147A: C9          ret
; ---------------------------------------------------------------------------

loc_147b:                                                       ; ...
147B: 21 3E E0    ld      hl,hi_score_left_repeat_tmr_e03e
147E: 34          inc     (hl)                            ; tick
147F: 7E          ld      a,(hl)
1480: FE 0F       cp      $F                            ; expired?
1482: C0          ret     NZ                              ; no,exit
1483: 18 E6       jr      loc_146b                        ; do repeat
; End of function check_hi_score_entry_left_145e

; ---------------------------------------------------------------------------
1485: C9          ret
; calculates score rank 1-6
; 6 = score didn't make table

; =============== S U B R O U T I N E =======================================


calc_score_rank_1486:                                                ; ...
1486: 3E 06       ld      a,6
1488: 32 32 E0    ld      (curr_score_rank_e032),a            ; init
148B: 11 41 EE    ld      de,p1_score_ee41
148E: 3A 01 EC    ld      a,(curr_player_ec01)
1491: E6 01       and     1                              ; p1_e002?
1493: 28 03       jr      Z,loc_1498                     ; yes,skip
1495: 11 44 EE    ld      de,p2_score_ee44

loc_1498:                                                       ; ...
1498: 21 34 EE    ld      hl,hi_score_5th_ee34
149B: 0E 05       ld      c,5                           ; 5 scores to check

loc_149d:                                                       ; ...
149D: 22 35 E0    ld      (tmp_ptr_hi_score_e035),hl
14A0: ED 53 33 E0 ld      (tmp_ptr_curr_score_e033),de
14A4: 06 03       ld      b,3                           ; 3 bytes to check

loc_14a6:                                                       ; ...
14A6: 1A          ld      a,(de)                         ; score byte
14A7: BE          cp      (hl)                            ; cmp hi score byte
14A8: 28 04       jr      Z,loc_14ae                     ; same,cont
14AA: 38 1D       jr      C,locret_14c9                  ; hi score higher,ret
14AC: 18 04       jr      loc_14b2                        ; score higher,go
; ---------------------------------------------------------------------------

loc_14ae:                                                       ; ...
14AE: 13          inc     de                              ; next score byte
14AF: 23          inc     hl                              ; next hi score byte
14B0: 10 F4       djnz    loc_14a6                        ; loop score bytes

loc_14b2:                                                       ; ...
14B2: 3A 32 E0    ld      a,(curr_score_rank_e032)
14B5: 3D          dec     a                               ; bump
14B6: 32 32 E0    ld      (curr_score_rank_e032),a
14B9: 2A 35 E0    ld      hl,(tmp_ptr_hi_score_e035)
14BC: ED 5B 33 E0 ld      de,(tmp_ptr_curr_score_e033)
14C0: 7D          ld      a,l
14C1: D6 0D       sub     $D                            ; next hi score entry
14C3: 6F          ld      l,a
14C4: 0D          dec     c
14C5: C2 9D 14    jp      NZ,loc_149d                    ; loop through hi score table
14C8: C9          ret
; ---------------------------------------------------------------------------

locret_14c9:                                                    ; ...
14C9: C9          ret
; End of function calc_score_rank_1486


; =============== S U B R O U T I N E =======================================


insert_hi_score_14ca:                                                ; ...
14CA: 3A 32 E0    ld      a,(curr_score_rank_e032)
14CD: FE 05       cp      5                              ; 5th?
14CF: 28 14       jr      Z,loc_14e5                     ; yes,go
14D1: 21 FF 14    ld      hl,thirteen_times_tbl_14ff
14D4: 3D          dec     a
14D5: E7          rst     content_hl_plus_a_0020               ; get pointer first score to move down
14D6: 4F          ld      c,a
14D7: 06 00       ld      b,0                           ; bytes to move down
14D9: 11 40 EE    ld      de,hi_name_5th_ee37+9             ; destination
14DC: 21 33 EE    ld      hl,hi_name_4th_ee2a+9             ; source
14DF: ED B8       lddr                                    ; move down
14E1: 23          inc     hl
14E2: C3 E8 14    jp      loc_14e8
; ---------------------------------------------------------------------------

loc_14e5:                                                       ; ...
14E5: 21 34 EE    ld      hl,hi_score_5th_ee34

loc_14e8:                                                       ; ...
14E8: ED 5B 33 E0 ld      de,(tmp_ptr_curr_score_e033)
14EC: EB          ex      de,hl
14ED: ED A0       ldi
14EF: ED A0       ldi
14F1: ED A0       ldi                                     ; copy curr score to hi score table entry
14F3: 06 03       ld      b,3                           ; 3 chars to init
14F5: EB          ex      de,hl
14F6: 22 3B E0    ld      (ptr_hi_score_entry_name_e03b),hl

loc_14f9:                                                       ; ...
14F9: 36 2E       ld      (hl),$2E ; '.'               ; '.'
14FB: 23          inc     hl                              ; next addr
14FC: 10 FB       djnz    loc_14f9                        ; loop
14FE: C9          ret
; End of function insert_hi_score_14ca

; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================


check_freeplay_1503:                                                 ; ...
1503: 3A 10 E0    ld      a,(freeplay_e010)
1506: A7          and     a                               ; freeplay_e010?
1507: C0          ret     NZ                              ; yes,return
1508: CD 43 15    call    sub_1543
150B: CD 12 15    call    check_coin1_1512
150E: CD 28 15    call    check_coin2_1528
1511: C9          ret
; End of function check_freeplay_1503


; =============== S U B R O U T I N E =======================================


check_coin1_1512:                                                    ; ...

; FUNCTION CHUNK AT ROM:1597 SIZE 0000002A BYTES

1512: 21 0F E0    ld      hl,coin1_debounce_buf_e00f
1515: 3A 01 E0    ld      a,(system_e001)
1518: 07          rlca
1519: CB 16       rl      (hl)                            ; coin1
151B: 7E          ld      a,(hl)
151C: E6 07       and     7                              ; last 3 read
151E: C8          ret     Z
151F: FE 03       cp      3                              ; 011?
1521: C0          ret     NZ                              ; no,return
1522: CD 8D 15    call    inc_coin1_cnt_158d
1525: C3 97 15    jp      loc_1597
; End of function check_coin1_1512


; =============== S U B R O U T I N E =======================================


check_coin2_1528:                                                    ; ...
1528: 21 0E E0    ld      hl,coin2_debounce_buf_e00e
152B: 3A 01 E0    ld      a,(system_e001)
152E: 07          rlca
152F: 07          rlca
1530: 00          nop
1531: 00          nop
1532: CB 16       rl      (hl)                            ; coin2
1534: 7E          ld      a,(hl)
1535: E6 07       and     7                              ; last 3 read
1537: C8          ret     Z
1538: FE 03       cp      3                              ; 011?
153A: C0          ret     NZ                              ; no,return
153B: CD 92 15    call    inc_coin2_cnt_1592
153E: 0E 01       ld      c,1
1540: C3 AB 15    jp      loc_15ab
; End of function check_coin2_1528


; =============== S U B R O U T I N E =======================================


sub_1543:                                                       ; ...

; FUNCTION CHUNK AT ROM:156B SIZE 00000022 BYTES

1543: CD 49 15    call    sub_1549
1546: C3 6B 15    jp      loc_156b
; End of function sub_1543


; =============== S U B R O U T I N E =======================================


sub_1549:                                                       ; ...
1549: 21 2F E0    ld      hl,flipscreen_something_e02f
154C: 11 82 EF    ld      de,flipscreen_shadow_ef82
154F: 7E          ld      a,(hl)
1550: A7          and     a
1551: 28 0C       jr      Z,loc_155f
1553: 35          dec     (hl)
1554: 7E          ld      a,(hl)
1555: FE 1F       cp      $1F
1557: 20 04       jr      NZ,loc_155d
1559: EB          ex      de,hl
155A: CB 86       res     0,(hl)
155C: EB          ex      de,hl

loc_155d:                                                       ; ...
155D: A7          and     a
155E: C0          ret     NZ

loc_155f:                                                       ; ...
155F: 2C          inc     l
1560: 7E          ld      a,(hl)
1561: A7          and     a
1562: C8          ret     Z
1563: 35          dec     (hl)
1564: 2D          dec     l
1565: 36 3F       ld      (hl),$3F ; '?'
1567: EB          ex      de,hl
1568: CB C6       set     0,(hl)
156A: C9          ret
; End of function sub_1549

; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR sub_1543

loc_156b:                                                       ; ...
156B: 21 9E E0    ld      hl,flipscreen_something___0_e09e
156E: 11 82 EF    ld      de,flipscreen_shadow_ef82
1571: 7E          ld      a,(hl)
1572: A7          and     a
1573: 28 0C       jr      Z,loc_1581
1575: 35          dec     (hl)
1576: 7E          ld      a,(hl)
1577: FE 3F       cp      $3F ; '?'
1579: 20 04       jr      NZ,loc_157f
157B: EB          ex      de,hl
157C: CB 8E       res     1,(hl)
157E: EB          ex      de,hl

loc_157f:                                                       ; ...
157F: A7          and     a
1580: C0          ret     NZ

loc_1581:                                                       ; ...
1581: 2C          inc     l
1582: 7E          ld      a,(hl)
1583: A7          and     a
1584: C8          ret     Z
1585: 35          dec     (hl)
1586: 2D          dec     l
1587: 36 7F       ld      (hl),$7F ; ''
1589: EB          ex      de,hl
158A: CB CE       set     1,(hl)
158C: C9          ret
; END OF FUNCTION CHUNK FOR sub_1543

; =============== S U B R O U T I N E =======================================


inc_coin1_cnt_158d:                                                  ; ...
158D: 21 30 E0    ld      hl,coin1_cnt_e030
1590: 34          inc     (hl)
1591: C9          ret
; End of function inc_coin1_cnt_158d


; =============== S U B R O U T I N E =======================================


inc_coin2_cnt_1592:                                                  ; ...
1592: 21 9F E0    ld      hl,coin2_cnt_e09f
1595: 34          inc     (hl)
1596: C9          ret
; End of function inc_coin2_cnt_1592

; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR check_coin1_1512

loc_1597:                                                       ; ...
1597: CD 23 47    call    snd_cmd_07_4723
159A: 3A 11 E0    ld      a,(coina_coins_e011)
159D: 47          ld      b,a                            ; coins/credit
159E: 21 15 E0    ld      hl,coina_coins_inserted_e015
15A1: 34          inc     (hl)                            ; inc inserted
15A2: 7E          ld      a,(hl)
15A3: B8          cp      b                               ; enough for a credit?
15A4: D8          ret     C                               ; no,exit
15A5: 36 00       ld      (hl),0                        ; init
15A7: 3A 13 E0    ld      a,(coina_credits_e013)              ; credits_e022/coin
15AA: 4F          ld      c,a                            ; save

loc_15ab:                                                       ; ...
15AB: 3A 22 E0    ld      a,(credits_e022)
15AE: FE 63       cp      99                             ; max?
15B0: D0          ret     NC                              ; yes,exit
15B1: 81          add     a,c                            ; add new credits_e022
15B2: 27          daa
15B3: 32 22 E0    ld      (credits_e022),a                    ; update
15B6: 3A 05 E0    ld      a,(vbl_lvl_0_fn_e005)
15B9: FE 03       cp      3                              ; test mode?
15BB: C8          ret     Z                               ; yes,exit
15BC: 16 06       ld      d,6                           ; print credits_e022
15BE: C3 38 00    jp      add_fn_to_q_0038
; END OF FUNCTION CHUNK FOR check_coin1_1512

; =============== S U B R O U T I N E =======================================


init_attract_mode_input_15c1:                                        ; ...
15C1: 3A 70 EF    ld      a,(attract_mode_planet_ef70)
15C4: 3D          dec     a
15C5: A7          and     a                               ; planet 1?
15C6: 28 1B       jr      Z,loc_15e3                     ; yes,go
15C8: 3D          dec     a                               ; planet 2?
15C9: 28 0C       jr      Z,loc_15d7                     ; yes,go
15CB: 21 C7 19    ld      hl,planet_3_attract_mode_tbl_19c7
15CE: 7E          ld      a,(hl)
15CF: 23          inc     hl
15D0: 22 00 E4    ld      (attract_mode_input_ptr_e400),hl
15D3: 32 02 E4    ld      (attract_mode_input_cnt_e402),a
15D6: C9          ret
; ---------------------------------------------------------------------------

loc_15d7:                                                       ; ...
15D7: 21 C7 17    ld      hl,planet_2_attract_mode_inp_tbl_17c7
15DA: 7E          ld      a,(hl)
15DB: 23          inc     hl
15DC: 22 00 E4    ld      (attract_mode_input_ptr_e400),hl
15DF: 32 02 E4    ld      (attract_mode_input_cnt_e402),a
15E2: C9          ret
; ---------------------------------------------------------------------------

loc_15e3:                                                       ; ...
15E3: 21 C7 16    ld      hl,planet_1_attract_mode_inp_tbl_16c7
15E6: 7E          ld      a,(hl)
15E7: 23          inc     hl
15E8: 22 00 E4    ld      (attract_mode_input_ptr_e400),hl
15EB: 32 02 E4    ld      (attract_mode_input_cnt_e402),a
15EE: C9          ret
; End of function init_attract_mode_input_15c1


; =============== S U B R O U T I N E =======================================


init_ship_obj_and_bomb_tbl_15ef:                                     ; ...
15EF: DD 21 00 E1 ld      ix,ship_obj_e100
15F3: FD 21 00 EF ld      iy,spriteram_shadow_ef00
15F7: DD 36 00 FF ld      (ix+$00),$FF                    ; flag active
15FB: FD 36 00 02 ld      (iy+$00),2                       ; s0.code
15FF: FD 36 01 00 ld      (iy+$01),0                       ; s0.colour
1603: FD 36 02 80 ld      (iy+$02),128                     ; s0.y
1607: FD 36 03 20 ld      (iy+$03),32                      ; s0.x
160B: CD C1 15    call    init_attract_mode_input_15c1
160E: 3A 70 EF    ld      a,(attract_mode_planet_ef70)
1611: 3D          dec     a
1612: A7          and     a                               ; planet 1?
1613: 28 19       jr      Z,loc_162e                     ; yes,go
1615: 3D          dec     a                               ; planet 2?
1616: 28 0B       jr      Z,loc_1623                     ; yes,go
1618: 21 71 16    ld      hl,planet_3_attr_mode_bomb_tbl_1671
161B: 22 00 E6    ld      (attr_mode_bomb_ptr_e600),hl
161E: 7E          ld      a,(hl)
161F: 32 03 E6    ld      (attr_mode_bomb_cnt_e603),a
1622: C9          ret
; ---------------------------------------------------------------------------

loc_1623:                                                       ; ...
1623: 21 51 16    ld      hl,planet_2_attr_mode_bomb_tbl_1651
1626: 22 00 E6    ld      (attr_mode_bomb_ptr_e600),hl
1629: 7E          ld      a,(hl)
162A: 32 03 E6    ld      (attr_mode_bomb_cnt_e603),a
162D: C9          ret
; ---------------------------------------------------------------------------

loc_162e:                                                       ; ...
162E: 21 39 16    ld      hl,planet_1_attr_mode_bomb_tbl_1639
1631: 22 00 E6    ld      (attr_mode_bomb_ptr_e600),hl
1634: 7E          ld      a,(hl)
1635: 32 03 E6    ld      (attr_mode_bomb_cnt_e603),a
1638: C9          ret
; End of function init_ship_obj_and_bomb_tbl_15ef

; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================


handle_attr_mode_bombing_1681:                                       ; ...
1681: 21 03 E6    ld      hl,attr_mode_bomb_cnt_e603
1684: 35          dec     (hl)
1685: C0          ret     NZ
1686: 2A 00 E6    ld      hl,(attr_mode_bomb_ptr_e600)
1689: 23          inc     hl
168A: 22 00 E6    ld      (attr_mode_bomb_ptr_e600),hl
168D: 7E          ld      a,(hl)
168E: 3C          inc     a
168F: 28 05       jr      Z,attr_mode_bomb_1696
1691: 3D          dec     a
1692: 32 03 E6    ld      (attr_mode_bomb_cnt_e603),a
1695: C9          ret
; ---------------------------------------------------------------------------

attr_mode_bomb_1696:                                                 ; ...
1696: 23          inc     hl
1697: 22 00 E6    ld      (attr_mode_bomb_ptr_e600),hl
169A: 7E          ld      a,(hl)
169B: 32 03 E6    ld      (attr_mode_bomb_cnt_e603),a
169E: C3 0B 1E    jp      start_bomb_1e0b
; End of function handle_attr_mode_bombing_1681


; =============== S U B R O U T I N E =======================================


attract_mode_move_ship_16a1:                                         ; ...
16A1: CD 81 16    call    handle_attr_mode_bombing_1681
16A4: 2A 00 E4    ld      hl,(attract_mode_input_ptr_e400)
16A7: 3A 02 E4    ld      a,(attract_mode_input_cnt_e402)
16AA: 3D          dec     a
16AB: 57          ld      d,a
16AC: E6 0F       and     $F                            ; done repeat?
16AE: 20 06       jr      NZ,loc_16b6                    ; no,skip
16B0: 7E          ld      a,(hl)                         ; get next repeat
16B1: 23          inc     hl                              ; inc ptr
16B2: 22 00 E4    ld      (attract_mode_input_ptr_e400),hl    ; update
16B5: 57          ld      d,a

loc_16b6:                                                       ; ...
16B6: 7A          ld      a,d
16B7: 32 02 E4    ld      (attract_mode_input_cnt_e402),a
16BA: 0F          rrca
16BB: 0F          rrca
16BC: 0F          rrca
16BD: 0F          rrca                                    ; high nibble to low
16BE: E6 0F       and     $F                            ; input only
16C0: 32 05 E4    ld      (attract_mode_input_e405),a         ; set curr input
16C3: CD BC 1A    call    move_ship_1abc
16C6: C9          ret
; End of function attract_mode_move_ship_16a1

; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================


init_player_sprite_1a97:                                             ; ...
1A97: FD 21 00 EF ld      iy,spriteram_shadow_ef00
1A9B: DD 21 00 E1 ld      ix,ship_obj_e100
1A9F: FD 36 00 02 ld      (iy+$00),2                       ; s0.code
1AA3: FD 36 01 00 ld      (iy+$01),0                       ; s0.colour
1AA7: FD 36 02 80 ld      (iy+$02),128                     ; s0.y
1AAB: FD 36 03 30 ld      (iy+$03),48                      ; s0.x
1AAF: 3E FF       ld      a,$FF
1AB1: DD 77 00    ld      (ix+$00),a                        ; init state=active
1AB4: AF          xor     a
1AB5: 32 9A E0    ld      (byte_e09a),a
1AB8: 32 99 E0    ld      (byte_e099),a
1ABB: C9          ret
; End of function init_player_sprite_1a97


; =============== S U B R O U T I N E =======================================


move_ship_1abc:                                                      ; ...
1ABC: FD 21 00 EF ld      iy,spriteram_shadow_ef00           ; s0.code
1AC0: DD 21 00 E1 ld      ix,ship_obj_e100
1AC4: DD 7E 00    ld      a,(ix+$00)                        ; state
1AC7: 3C          inc     a                               ; active?
1AC8: 20 0A       jr      NZ,handle_explosion_1ad4            ; no,go
1ACA: CD 61 1B    call    move_ship_up_down_1b61
1ACD: CD 9C 1B    call    move_ship_left_right_1b9c
1AD0: CD F9 1B    call    adjust_ship_sprite_1bf9
1AD3: C9          ret
; ---------------------------------------------------------------------------

handle_explosion_1ad4:                                               ; ...
1AD4: FE 40       cp      $40 ; '@'                     ; starting to explode?
1AD6: CC 2E 1B    call    Z,init_explosion_1b2e               ; yes,go
1AD9: DD 7E 02    ld      a,(ix+$02)                        ; explosion frame tmr
1ADC: A7          and     a                               ; done frame?
1ADD: 28 04       jr      Z,get_explosion_frame_1ae3          ; ues,go
1ADF: DD 35 02    dec     (ix+$02)                           ; update tmr
1AE2: C9          ret
; ---------------------------------------------------------------------------

get_explosion_frame_1ae3:                                            ; ...
1AE3: DD 7E 01    ld      a,(ix+$01)                        ; explosion frame cnt
1AE6: DD 34 01    inc     (ix+$01)
1AE9: 21 1C 1B    ld      hl,explosion_sprite_code_y_tbl_1b1c
1AEC: 87          add     a,a                            ; x2
1AED: E7          rst     content_hl_plus_a_0020
1AEE: FE FF       cp      $FF                           ; end of table?
1AF0: 28 0E       jr      Z,end_explosion_1b00                ; yes,go
1AF2: FD 77 00    ld      (iy+$00),a                        ; sn.code
1AF5: C6 02       add     a,2
1AF7: FD 77 04    ld      (iy+$04),a                        ; s(n+1).code
1AFA: 23          inc     hl
1AFB: 7E          ld      a,(hl)                         ; explosion frame tmr
1AFC: DD 77 02    ld      (ix+$02),a                        ; init
1AFF: C9          ret
; ---------------------------------------------------------------------------

end_explosion_1b00:                                                  ; ...
1B00: 3A 05 E0    ld      a,(vbl_lvl_0_fn_e005)
1B03: 3D          dec     a                               ; attract mode?
1B04: 28 0B       jr      Z,loc_1b11                     ; yes,go
1B06: AF          xor     a
1B07: DD 77 00    ld      (ix+$00),a                        ; deactivate
1B0A: DD 77 01    ld      (ix+$01),a                        ; frame cnt
1B0D: DD 77 02    ld      (ix+$02),a                        ; frame tmr
1B10: C9          ret
; ---------------------------------------------------------------------------

loc_1b11:                                                       ; ...
1B11: AF          xor     a
1B12: DD 77 00    ld      (ix+$00),a                        ; deactivate
1B15: DD 77 01    ld      (ix+$01),a                        ; frame cnt
1B18: DD 77 02    ld      (ix+$02),a                        ; frame tmr
1B1B: C9          ret
; End of function move_ship_1abc

; ---------------------------------------------------------------------------
; sprite code,frame cnt

; =============== S U B R O U T I N E =======================================


init_explosion_1b2e:                                                 ; ...
1B2E: FD 7E 02    ld      a,(iy+$02)                        ; sn.y
1B31: D6 08       sub     8
1B33: FD 77 02    ld      (iy+$02),a                        ; update
1B36: FD 77 06    ld      (iy+$06),a                        ; update s(n+1).y
1B39: FD 7E 03    ld      a,(iy+$03)                        ; sn.x
1B3C: C6 08       add     a,8
1B3E: FD 77 03    ld      (iy+$03),a                        ; update
1B41: D6 10       sub     $10
1B43: FD 77 07    ld      (iy+$07),a                        ; update s(n+1).x
1B46: 3E 01       ld      a,1
1B48: DD 77 00    ld      (ix+$00),a                        ; update obj state
1B4B: AF          xor     a
1B4C: DD 77 01    ld      (ix+$01),a                        ; explosion frame cnt
1B4F: DD 77 02    ld      (ix+$02),a                        ; explosion frame tmr
1B52: FD 36 01 40 ld      (iy+$01),$40 ; '@'              ; sn.colour
1B56: FD 36 05 40 ld      (iy+$05),$40 ; '@'              ; s(n+1).colour
1B5A: CD 58 47    call    stop_bomb_snd_4758
1B5D: CD 8D 47    call    snd_cmd_02_478d
1B60: C9          ret
; End of function init_explosion_1b2e


; =============== S U B R O U T I N E =======================================


move_ship_up_down_1b61:                                              ; ...
1B61: CD 66 1C    call    read_controller_inputs_1c66
1B64: E6 0F       and     $F                            ; joystick only
1B66: C8          ret     Z                               ; not moving,return
1B67: 47          ld      b,a                            ; save
1B68: E6 03       and     3                              ; left/right only
1B6A: 4F          ld      c,a                            ; save
1B6B: CB 58       bit     3,b                            ; up?
1B6D: 20 0F       jr      NZ,ship_up_1b7e                     ; yes,go
1B6F: CB 50       bit     2,b                            ; down?
1B71: C8          ret     Z                               ; no,exit

ship_down_1b72:                                                      ; dx
1B72: 11 80 FE    ld      de,-384
1B75: 79          ld      a,c                            ; left/right only
1B76: A7          and     a                               ; neither?
1B77: 28 0F       jr      Z,update_ship_x_1b88                ; yes,go
1B79: 11 00 FF    ld      de,-256                       ; dx
1B7C: 18 0A       jr      update_ship_x_1b88
; ---------------------------------------------------------------------------

ship_up_1b7e:                                                        ; ...
1B7E: 11 80 01    ld      de,384                        ; dx
1B81: 79          ld      a,c                            ; left/right only
1B82: A7          and     a                               ; neither?
1B83: 28 03       jr      Z,update_ship_x_1b88                ; yes,go
1B85: 11 00 01    ld      de,256                        ; dx

update_ship_x_1b88:                                                  ; ...
1B88: DD 6E 07    ld      l,(ix+$07)                        ; ship x lsb
1B8B: FD 66 03    ld      h,(iy+$03)                        ; s0.x
1B8E: 19          add     hl,de                          ; calc new x
1B8F: 7C          ld      a,h
1B90: D6 08       sub     8                              ; adjust
1B92: FE B8       cp      184                            ; out of area?
1B94: D0          ret     NC                              ; yes,return
1B95: FD 74 03    ld      (iy+$03),h                        ; update s0.x
1B98: DD 75 07    ld      (ix+$07),l                        ; update ship x lsb
1B9B: C9          ret
; End of function move_ship_up_down_1b61


; =============== S U B R O U T I N E =======================================


move_ship_left_right_1b9c:                                           ; ...
1B9C: CD 66 1C    call    read_controller_inputs_1c66
1B9F: 47          ld      b,a                            ; save
1BA0: A7          and     a                               ; moving?
1BA1: 28 4C       jr      Z,cant_move_left_right_1bef         ; no,go
1BA3: CB 47       bit     0,a                            ; right?
1BA5: 20 26       jr      NZ,move_ship_right_1bcd             ; yes,go
1BA7: CB 4F       bit     1,a                            ; left?
1BA9: 28 44       jr      Z,cant_move_left_right_1bef         ; no,go
1BAB: FD 7E 02    ld      a,(iy+$02)                        ; s0.y
1BAE: FE 10       cp      16                             ; left-most?
1BB0: 28 3D       jr      Z,cant_move_left_right_1bef         ; yes,go

move_ship_left_1bb2:                                                 ; ship y msb
1BB2: 57          ld      d,a
1BB3: DD 5E 06    ld      e,(ix+$06)                        ; ship y lsb
1BB6: 21 C0 00    ld      hl,192                        ; airborne obj dy
1BB9: 22 09 E1    ld      (airborne_dy_e109),hl               ; update
1BBC: 21 10 FF    ld      hl,-240                       ; ground-based obj dy
1BBF: 22 0B E1    ld      (ground_dy_e10b),hl                 ; update
1BC2: 21 00 FF    ld      hl,-256                       ; dy
1BC5: 19          add     hl,de                          ; calc new y
1BC6: FD 74 02    ld      (iy+$02),h                        ; update s0.y
1BC9: DD 75 06    ld      (ix+$06),l                        ; ship y lsb
1BCC: C9          ret
; ---------------------------------------------------------------------------

move_ship_right_1bcd:                                                ; ...
1BCD: FD 7E 02    ld      a,(iy+$02)                        ; s0.y
1BD0: FE E0       cp      224                            ; right-most?
1BD2: 28 1B       jr      Z,cant_move_left_right_1bef         ; yes,go
1BD4: 57          ld      d,a
1BD5: DD 5E 06    ld      e,(ix+$06)                        ; ship y lsb
1BD8: 21 40 FF    ld      hl,-192                       ; airborne obj dy
1BDB: 22 09 E1    ld      (airborne_dy_e109),hl               ; update
1BDE: 21 F0 00    ld      hl,240                        ; ground-based obj dy
1BE1: 22 0B E1    ld      (ground_dy_e10b),hl                 ; update
1BE4: 21 00 01    ld      hl,256                        ; dy
1BE7: 19          add     hl,de                          ; calc new y
1BE8: FD 74 02    ld      (iy+$02),h                        ; update s0.y
1BEB: DD 75 06    ld      (ix+$06),l                        ; ship y lsb
1BEE: C9          ret
; ---------------------------------------------------------------------------

cant_move_left_right_1bef:                                           ; ...
1BEF: 21 00 00    ld      hl,0
1BF2: 22 09 E1    ld      (airborne_dy_e109),hl               ; update
1BF5: 22 0B E1    ld      (ground_dy_e10b),hl                 ; update
1BF8: C9          ret
; End of function move_ship_left_right_1b9c


; =============== S U B R O U T I N E =======================================


adjust_ship_sprite_1bf9:                                             ; ...
1BF9: CD 24 1C    call    ship_left_right_1c24
1BFC: DD 7E 08    ld      a,(ix+$08)
1BFF: A7          and     a
1C00: C8          ret     Z
1C01: C6 40       add     a,$40 ; '@'
1C03: 0F          rrca
1C04: 0F          rrca
1C05: 0F          rrca
1C06: E6 0F       and     $F
1C08: 21 14 1C    ld      hl,ship_code_tbl_1c14
1C0B: E7          rst     content_hl_plus_a_0020               ; get code entry
1C0C: FD 77 00    ld      (iy+$00),a                        ; set sprite code
1C0F: FD 36 01 00 ld      (iy+$01),0                       ; set sprite colour
1C13: C9          ret
; End of function adjust_ship_sprite_1bf9

; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================


ship_left_right_1c24:                                                ; ...
1C24: CD 66 1C    call    read_controller_inputs_1c66
1C27: E6 03       and     3                              ; left/right only
1C29: 28 1A       jr      Z,ship_steady_1c45                  ; neither,go
1C2B: CB 47       bit     0,a                            ; right?
1C2D: 20 02       jr      NZ,ship_right_1c31                  ; yes,go
1C2F: 18 0A       jr      ship_left_1c3b
; ---------------------------------------------------------------------------

ship_right_1c31:                                                     ; ...
1C31: CD 4E 1C    call    sub_1c4e
1C34: CD 4E 1C    call    sub_1c4e
1C37: CD 4E 1C    call    sub_1c4e
1C3A: C9          ret
; ---------------------------------------------------------------------------

ship_left_1c3b:                                                      ; ...
1C3B: CD 5A 1C    call    sub_1c5a
1C3E: CD 5A 1C    call    sub_1c5a
1C41: CD 5A 1C    call    sub_1c5a
1C44: C9          ret
; ---------------------------------------------------------------------------

ship_steady_1c45:                                                    ; ...
1C45: DD 7E 08    ld      a,(ix+$08)
1C48: A7          and     a
1C49: C8          ret     Z
1C4A: CB 7F       bit     7,a
1C4C: 20 0C       jr      NZ,sub_1c5a
; End of function ship_left_right_1c24


; =============== S U B R O U T I N E =======================================


sub_1c4e:                                                       ; ...
1C4E: DD 7E 08    ld      a,(ix+$08)
1C51: C6 40       add     a,$40 ; '@'
1C53: FE 02       cp      2
1C55: D8          ret     C
1C56: DD 35 08    dec     (ix+$08)
1C59: C9          ret
; End of function sub_1c4e


; =============== S U B R O U T I N E =======================================


sub_1c5a:                                                       ; ...
1C5A: DD 7E 08    ld      a,(ix+$08)
1C5D: C6 40       add     a,$40 ; '@'
1C5F: FE 7E       cp      $7E ; '~'
1C61: D0          ret     NC
1C62: DD 34 08    inc     (ix+$08)
1C65: C9          ret
; End of function sub_1c5a


; =============== S U B R O U T I N E =======================================


read_controller_inputs_1c66:                                         ; ...
1C66: 3A 05 E0    ld      a,(vbl_lvl_0_fn_e005)
1C69: 3D          dec     a                               ; attract mode?
1C6A: 28 0D       jr      Z,get_attract_mode_input_1c79       ; yes,go
1C6C: 21 02 E0    ld      hl,p1_e002                         ; p1_e002 inputs
1C6F: 3A 07 E0    ld      a,(curr_controls_e007)
1C72: E6 01       and     1                              ; using p1_e002 controls?
1C74: 28 01       jr      Z,loc_1c77                     ; yes,skip
1C76: 2C          inc     l                               ; use p2_e003 controls

loc_1c77:                                                       ; ...
1C77: 7E          ld      a,(hl)                         ; read controls
1C78: C9          ret
; ---------------------------------------------------------------------------

get_attract_mode_input_1c79:                                         ; ...
1C79: 3A 05 E4    ld      a,(attract_mode_input_e405)
1C7C: C9          ret
; End of function read_controller_inputs_1c66


; =============== S U B R O U T I N E =======================================


init_bullet_and_bomb_objs_1c7d:                                      ; ...
1C7D: DD 21 10 E1 ld      ix,bullet_obj_tbl_e110
1C81: 06 04       ld      b,4                           ; 4 bullets to init
1C83: 11 10 00    ld      de,$10                       ; bytes per object

loc_1c86:                                                       ; ...
1C86: DD 36 00 3F ld      (ix+$00),$3F ; '?'              ; status=???
1C8A: DD 19       add     ix,de                          ; next object entry
1C8C: 10 F8       djnz    loc_1c86                        ; loop
1C8E: 3E 07       ld      a,7
1C90: 32 53 E1    ld      (bomb_obj_e150+3),a
1C93: 11 00 0D    ld      de,$D00                      ; print bombs
1C96: FF          rst     add_fn_to_q_0038
1C97: CD 58 47    call    stop_bomb_snd_4758
1C9A: C9          ret
; End of function init_bullet_and_bomb_objs_1c7d


; =============== S U B R O U T I N E =======================================


handle_firing_bullets_and_upd_bombs_1c9b:                            ; ...
1C9B: CD 4C 1D    call    handle_firing_if_ship_active_1d4c
1C9E: CD A5 1C    call    update_sprite_bullets_1ca5
1CA1: CD 46 1E    call    update_bomb_if_ship_active_1e46
1CA4: C9          ret
; End of function handle_firing_bullets_and_upd_bombs_1c9b


; =============== S U B R O U T I N E =======================================


update_sprite_bullets_1ca5:                                          ; ...

; FUNCTION CHUNK AT ROM:2990 SIZE 00000009 BYTES

1CA5: DD 21 10 E1 ld      ix,bullet_obj_tbl_e110
1CA9: FD 21 10 EF ld      iy,spriteram_shadow_ef00+0x10     ; s4
1CAD: 06 04       ld      b,4

loc_1caf:                                                       ; ...
1CAF: C5          push    bc
1CB0: DD 7E 00    ld      a,(ix+$00)
1CB3: A7          and     a                               ; inactive?
1CB4: 28 0A       jr      Z,loc_1cc0                     ; yes,skip
1CB6: 21 C0 1C    ld      hl,loc_1cc0					; [push_function]
1CB9: E5          push    hl                              ; set return addr 
1CBA: 3C          inc     a                               ; active?
1CBB: 28 11       jr      Z,move_player_sprite_bullet_1cce    ; yes,go
1CBD: C3 90 29    jp      deactivate_obj_2990
; ---------------------------------------------------------------------------

loc_1cc0:                                                       ; ...
1CC0: C1          pop     bc
1CC1: 11 04 00    ld      de,4
1CC4: FD 19       add     iy,de                          ; next sprite
1CC6: 11 10 00    ld      de,$10
1CC9: DD 19       add     ix,de                          ; next object
1CCB: 10 E2       djnz    loc_1caf
1CCD: C9          ret
; ---------------------------------------------------------------------------

move_player_sprite_bullet_1cce:                                      ; ...
1CCE: DD 7E 01    ld      a,(ix+$01)                        ; obj y msb
1CD1: 57          ld      d,a
1CD2: FE 06       cp      6                              ; off-screen?
1CD4: DA 90 29    jp      C,deactivate_obj_2990               ; yes,go
1CD7: DD 5E 02    ld      e,(ix+$02)                        ; obj y lsb
1CDA: 2A 09 E1    ld      hl,(airborne_dy_e109)
1CDD: 19          add     hl,de                          ; move w/bg
1CDE: DD 74 01    ld      (ix+$01),h                        ; update y msb
1CE1: DD 75 02    ld      (ix+$02),l                        ; update y lsb
1CE4: 7C          ld      a,h
1CE5: C6 06       add     a,6                           ; adjustment
1CE7: FD 77 02    ld      (iy+$02),a                        ; update sprite y
1CEA: DD 7E 03    ld      a,(ix+$03)                        ; obj x msb
1CED: 57          ld      d,a
1CEE: FE E8       cp      232                            ; off-screen?
1CF0: D2 90 29    jp      NC,deactivate_obj_2990              ; yes,go
1CF3: DD 5E 04    ld      e,(ix+$04)                        ; obj x lsb
1CF6: 21 00 05    ld      hl,$500                      ; obj dx
1CF9: 19          add     hl,de                          ; calc obj x
1CFA: DD 74 03    ld      (ix+$03),h                        ; update obj x msb
1CFD: DD 75 04    ld      (ix+$04),l                        ; update obj x lsb
1D00: FD 74 03    ld      (iy+$03),h                        ; update sprite x
1D03: 3A 00 E0    ld      a,(vblank_tick_e000)
1D06: E6 01       and     1
1D08: C6 1E       add     a,$1E                        ; animate sprite code
1D0A: FD 77 00    ld      (iy+$00),a                        ; sprite code
1D0D: FD 36 01 00 ld      (iy+$01),0                       ; sprite colour
1D11: C9          ret
; End of function update_sprite_bullets_1ca5


; =============== S U B R O U T I N E =======================================


update_player_bullets_and_bombs_1d12:                                ; ...
1D12: CD 4C 1D    call    handle_firing_if_ship_active_1d4c
1D15: CD 90 1D    call    update_player_fg_bullets_1d90
1D18: CD 1F 1D    call    handle_bombing_1d1f
1D1B: CD 46 1E    call    update_bomb_if_ship_active_1e46
1D1E: C9          ret
; End of function update_player_bullets_and_bombs_1d12


; =============== S U B R O U T I N E =======================================


handle_bombing_1d1f:                                                 ; ...
1D1F: 3A 05 E0    ld      a,(vbl_lvl_0_fn_e005)
1D22: 3D          dec     a                               ; attract mode?
1D23: C8          ret     Z                               ; yes,return
1D24: 3A 00 E1    ld      a,(ship_obj_e100)
1D27: 3C          inc     a                               ; active?
1D28: C0          ret     NZ                              ; no,exit
1D29: 3A 0D E0    ld      a,(curr_player_b2_e00d)
1D2C: E6 07       and     7                              ; last 3 read
1D2E: FE 03       cp      3                              ; 011?
1D30: C0          ret     NZ                              ; no,exit
1D31: 3A 50 E1    ld      a,(bomb_obj_e150)
1D34: A7          and     a                               ; already active?
1D35: C0          ret     NZ                              ; yes,exit
1D36: 3A 06 E5    ld      a,(curr_num_bombs_e506)
1D39: A7          and     a                               ; any bombs left?
1D3A: C8          ret     Z                               ; no,exit
1D3B: C3 0B 1E    jp      start_bomb_1e0b
; End of function handle_bombing_1d1f

; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR handle_firing_if_ship_active_1d4c

handle_attract_mode_firing_1d3e:                                     ; ...
1D3E: 3A 00 E0    ld      a,(vblank_tick_e000)
1D41: E6 0F       and     $F                            ; time to fire?
1D43: C0          ret     NZ                              ; no,return
1D44: 3A 50 E1    ld      a,(bomb_obj_e150)                   ; obj state
1D47: 3C          inc     a                               ; active?
1D48: C8          ret     Z                               ; yes,return
1D49: C3 5F 1D    jp      handle_firing_1d5f
; END OF FUNCTION CHUNK FOR handle_firing_if_ship_active_1d4c

; =============== S U B R O U T I N E =======================================


handle_firing_if_ship_active_1d4c:                                   ; ...

; FUNCTION CHUNK AT ROM:1D3E SIZE 0000000E BYTES

1D4C: 3A 00 E1    ld      a,(ship_obj_e100)
1D4F: 3C          inc     a                               ; active?
1D50: C0          ret     NZ                              ; no,return
1D51: 3A 05 E0    ld      a,(vbl_lvl_0_fn_e005)
1D54: 3D          dec     a                               ; attract mode?
1D55: 28 E7       jr      Z,handle_attract_mode_firing_1d3e   ; yes,go
1D57: 3A 0C E0    ld      a,(curr_player_b1_e00c)
1D5A: E6 07       and     7                              ; last 3 reads
1D5C: FE 03       cp      3                              ; 011?
1D5E: C0          ret     NZ                              ; no,return

handle_firing_1d5f:                                                  ; ...
1D5F: DD 21 10 E1 ld      ix,bullet_obj_tbl_e110
1D63: 11 10 00    ld      de,$10
1D66: 06 04       ld      b,4                           ; 4 bullet slots

loc_1d68:                                                       ; ...
1D68: DD 7E 00    ld      a,(ix+$00)
1D6B: A7          and     a                               ; free slot?
1D6C: 28 05       jr      Z,add_player_bullet_obj_1d73        ; yes,go
1D6E: DD 19       add     ix,de                          ; next slot
1D70: 10 F6       djnz    loc_1d68
1D72: C9          ret
; ---------------------------------------------------------------------------

add_player_bullet_obj_1d73:                                          ; ...
1D73: 3A 02 EF    ld      a,(spriteram_shadow_ef00+2)         ; s0.y
1D76: C6 FA       add     a,-6                          ; adjust
1D78: DD 77 01    ld      (ix+$01),a                        ; update obj y msb
1D7B: 3A 03 EF    ld      a,(spriteram_shadow_ef00+3)         ; s0.x
1D7E: C6 09       add     a,9                           ; adjust
1D80: DD 77 03    ld      (ix+$03),a                        ; update obj x msb
1D83: DD 36 00 FF ld      (ix+$00),$FF                    ; flag active
1D87: DD 36 05 00 ld      (ix+$05),0                       ; flag fg videoram addr invalid
1D8B: 3E 5F       ld      a,$5F ; '_'                  ; *** gets overwritten (alien bullet!!!)
1D8D: C3 5D 47    jp      play_bullet_snd_475d
; End of function handle_firing_if_ship_active_1d4c


; =============== S U B R O U T I N E =======================================


update_player_fg_bullets_1d90:                                       ; ...
1D90: DD 21 10 E1 ld      ix,bullet_obj_tbl_e110
1D94: FD 21 10 EF ld      iy,spriteram_shadow_ef00+0x10     ; *** NOT USED (s4.code)
1D98: 06 04       ld      b,4                           ; 4 bullets

loc_1d9a:                                                       ; ...
1D9A: C5          push    bc
1D9B: DD 7E 00    ld      a,(ix+$00)                        ; status
1D9E: A7          and     a                               ; inactive?
1D9F: 28 0C       jr      Z,loc_1dad                     ; yes,skip
1DA1: 21 AD 1D    ld      hl,loc_1dad					; [push_function]
1DA4: E5          push    hl                              ; save return address
1DA5: 3C          inc     a                               ; active?
1DA6: 28 13       jr      Z,move_player_fg_bullet_1dbb        ; yes,go
1DA8: 3C          inc     a                               ; new????
1DA9: 28 4A       jr      Z,loc_1df5                     ; yes,go
1DAB: 18 4F       jr      wipe_and_deactivate_bullet_1dfc
; ---------------------------------------------------------------------------

loc_1dad:                                                       ; ...
1DAD: C1          pop     bc
1DAE: 11 10 00    ld      de,$10
1DB1: DD 19       add     ix,de                          ; next object
1DB3: 11 04 00    ld      de,4
1DB6: FD 19       add     iy,de                          ; next sprite
1DB8: 10 E0       djnz    loc_1d9a                        ; loop
1DBA: C9          ret
; ---------------------------------------------------------------------------

move_player_fg_bullet_1dbb:                                          ; ...
1DBB: DD 7E 05    ld      a,(ix+$05)
1DBE: DD 6E 06    ld      l,(ix+$06)                        ; next row address in fg_videoram
1DC1: A7          and     a                               ; valid?
1DC2: C4 91 1E    call    NZ,wipe_player_bullet_on_fg_1e91    ; yes,go
1DC5: 2A 09 E1    ld      hl,(airborne_dy_e109)
1DC8: DD 56 01    ld      d,(ix+$01)                        ; obj y msb
1DCB: DD 5E 02    ld      e,(ix+$02)                        ; obj y lsb
1DCE: 19          add     hl,de                          ; move w/bg
1DCF: 7C          ld      a,h
1DD0: FE 06       cp      6                              ; off-screen?
1DD2: 38 28       jr      C,wipe_and_deactivate_bullet_1dfc   ; yes,go
1DD4: 7C          ld      a,h
1DD5: DD 74 01    ld      (ix+$01),h                        ; update obj y msb
1DD8: DD 75 02    ld      (ix+$02),l                        ; update obj y lsb
1DDB: DD 56 03    ld      d,(ix+$03)                        ; obj x msb
1DDE: DD 5E 04    ld      e,(ix+$04)                        ; obj x lsb
1DE1: 21 00 05    ld      hl,$500
1DE4: 19          add     hl,de                          ; calc obj x
1DE5: 7C          ld      a,h
1DE6: FE EC       cp      236                            ; off-screen?
1DE8: 30 12       jr      NC,wipe_and_deactivate_bullet_1dfc  ; yes,go
1DEA: 7C          ld      a,h
1DEB: DD 74 03    ld      (ix+$03),h                        ; update obj x msb
1DEE: DD 74 04    ld      (ix+$04),h                        ; update obj x lsb
1DF1: CD B7 1E    call    render_player_bullet_on_fg_1eb7
1DF4: C9          ret
; ---------------------------------------------------------------------------

loc_1df5:                                                       ; ...
1DF5: DD 35 07    dec     (ix+$07)                           ; WTF? where is this initialised?
1DF8: C0          ret     NZ
1DF9: C3 73 1D    jp      add_player_bullet_obj_1d73
; ---------------------------------------------------------------------------

wipe_and_deactivate_bullet_1dfc:                                     ; ...
1DFC: DD 7E 05    ld      a,(ix+$05)
1DFF: DD 6E 06    ld      l,(ix+$06)                        ; fg_videoram addr
1E02: A7          and     a                               ; valid?
1E03: C4 91 1E    call    NZ,wipe_player_bullet_on_fg_1e91    ; yes,go
1E06: DD 36 00 00 ld      (ix+$00),0                       ; state=inactive
1E0A: C9          ret
; End of function update_player_fg_bullets_1d90


; =============== S U B R O U T I N E =======================================


start_bomb_1e0b:                                                     ; ...
1E0B: 3A 06 E5    ld      a,(curr_num_bombs_e506)
1E0E: 3D          dec     a
1E0F: 32 06 E5    ld      (curr_num_bombs_e506),a             ; update
1E12: 21 08 E5    ld      hl,bomb_fired__maybe_e508
1E15: 34          inc     (hl)
1E16: 11 00 0D    ld      de,$D00                      ; show bombs
1E19: FF          rst     add_fn_to_q_0038
1E1A: FD 21 04 EF ld      iy,spriteram_shadow_ef00+4        ; s1.code
1E1E: DD 21 50 E1 ld      ix,bomb_obj_e150
1E22: 3A 02 EF    ld      a,(spriteram_shadow_ef00+2)         ; s0.y
1E25: FD 77 02    ld      (iy+$02),a                        ; copy to s1.y
1E28: 3A 03 EF    ld      a,(spriteram_shadow_ef00+3)         ; s0.x
1E2B: FD 77 03    ld      (iy+$03),a                        ; copy to s1.x
1E2E: FD 36 00 05 ld      (iy+$00),5                       ; s1.code (bomb)
1E32: FD 36 01 00 ld      (iy+$01),0                       ; s1.colour
1E36: DD 36 03 07 ld      (ix+$03),7
1E3A: DD 36 04 00 ld      (ix+$04),0                       ; hit count
1E3E: DD 36 00 FF ld      (ix+$00),$FF                    ; flag active
1E42: CD 48 47    call    play_bomb_snd_4748
1E45: C9          ret
; End of function start_bomb_1e0b


; =============== S U B R O U T I N E =======================================


update_bomb_if_ship_active_1e46:                                     ; ...
1E46: 3A 00 E1    ld      a,(ship_obj_e100)
1E49: 3C          inc     a                               ; active?
1E4A: C0          ret     NZ                              ; no,exit

update_bomb_1e4b:                                                    ; ...
1E4B: DD 21 50 E1 ld      ix,bomb_obj_e150
1E4F: FD 21 04 EF ld      iy,spriteram_shadow_ef00+4        ; s1.code
1E53: DD 7E 00    ld      a,(ix+$00)
1E56: A7          and     a                               ; inactive?
1E57: C8          ret     Z                               ; yes,exit
1E58: 3C          inc     a                               ; active?
1E59: C2 8B 1E    jp      NZ,deactivate_bomb_1e8b             ; no,go
1E5C: FD 56 02    ld      d,(iy+$02)                        ; s1.y
1E5F: DD 5E 01    ld      e,(ix+$01)                        ; obj y lsb
1E62: 2A 09 E1    ld      hl,(airborne_dy_e109)
1E65: 19          add     hl,de                          ; move w/bg
1E66: 7C          ld      a,h
1E67: C6 10       add     a,16                          ; adjust
1E69: FE 20       cp      32                             ; off-screen?
1E6B: DA 8B 1E    jp      C,deactivate_bomb_1e8b              ; yes,go
1E6E: FD 74 02    ld      (iy+$02),h                        ; update s1.y
1E71: DD 75 01    ld      (ix+$01),l                        ; update obj y lsb
1E74: FD 56 03    ld      d,(iy+$03)                        ; s1.x
1E77: DD 5E 02    ld      e,(ix+$02)                        ; obj x lsb
1E7A: 21 00 05    ld      hl,$500                      ; bomb dx
1E7D: 19          add     hl,de                          ; move bomb
1E7E: 7C          ld      a,h
1E7F: FE F0       cp      240                            ; off-screen?
1E81: D2 8B 1E    jp      NC,deactivate_bomb_1e8b             ; yes,go
1E84: FD 74 03    ld      (iy+$03),h                        ; update s1.x
1E87: DD 75 02    ld      (ix+$02),l                        ; update obj x lsb
1E8A: C9          ret
; ---------------------------------------------------------------------------

deactivate_bomb_1e8b:                                                ; ...
1E8B: CD 58 47    call    stop_bomb_snd_4758
1E8E: C3 90 29    jp      deactivate_obj_2990
; End of function update_bomb_if_ship_active_1e46


; =============== S U B R O U T I N E =======================================


wipe_player_bullet_on_fg_1e91:                                       ; ...
1E91: 67          ld      h,a                            ; fg videoram address msb
1E92: 36 20       ld      (hl),$20 ; ' '               ; blank tile    [video_address]
1E94: 2C          inc     l                               ; prev row
1E95: 36 20       ld      (hl),$20 ; ' '               ; blank tile    [video_address]
1E97: 3E 20       ld      a,$20 ; ' '
1E99: DF          rst     hl_plus_equals_a_0018                ; next column
1E9A: 36 20       ld      (hl),$20 ; ' '               ; blank tile    [video_address]
1E9C: 2D          dec     l                               ; prev row
1E9D: 36 20       ld      (hl),$20 ; ' '               ; blank tile    [video_address]
1E9F: 3E 20       ld      a,$20 ; ' '
1EA1: DF          rst     hl_plus_equals_a_0018                ; next column
1EA2: 36 20       ld      (hl),$20 ; ' '               ; blank tile    [video_address]
1EA4: 2C          inc     l                               ; prev row
1EA5: 36 20       ld      (hl),$20 ; ' '               ; blank tile    [video_address]
1EA7: C9          ret
; End of function wipe_player_bullet_on_fg_1e91

; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================


render_player_bullet_on_fg_1eb7:                                     ; ...
1EB7: 11 00 00    ld      de,0
1EBA: DD 7E 01    ld      a,(ix+$01)                        ; obj y msb
1EBD: C6 04       add     a,4
1EBF: 07          rlca
1EC0: CB 12       rl      d                               ; x2
1EC2: 07          rlca
1EC3: CB 12       rl      d                               ; x4
1EC5: E6 E0       and     $E0 ; '�'
1EC7: 5F          ld      e,a
1EC8: DD 7E 03    ld      a,(ix+$03)                        ; obj x msb
1ECB: C6 04       add     a,4
1ECD: 0F          rrca                                    ; /2
1ECE: 0F          rrca                                    ; /4
1ECF: 0F          rrca                                    ; /8
1ED0: E6 1F       and     $1F
1ED2: 83          add     a,e
1ED3: 5F          ld      e,a
1ED4: 21 00 D0    ld      hl,fgvideoram_code_d000
1ED7: 19          add     hl,de                          ; calc fg ram address
1ED8: EB          ex      de,hl
1ED9: DD 7E 01    ld      a,(ix+$01)                        ; obj y msb
1EDC: E6 07       and     7                              ; low 3 bits
1EDE: 6F          ld      l,a                            ; save
1EDF: DD 7E 03    ld      a,(ix+$03)                        ; obj x msb
1EE2: E6 07       and     7                              ; low 3 bits
1EE4: 87          add     a,a
1EE5: 87          add     a,a
1EE6: 87          add     a,a                            ; shift 0-2 -> 3-5
1EE7: 85          add     a,l                            ; add y low 3 bits
1EE8: 6F          ld      l,a
1EE9: 26 00       ld      h,0
1EEB: 29          add     hl,hl                          ; x2
1EEC: 44          ld      b,h
1EED: 4D          ld      c,l
1EEE: 29          add     hl,hl                          ; x4
1EEF: 09          add     hl,bc                          ; x6
1EF0: 01 3E 1F    ld      bc,bullet_tile_code_tbl_1f3e
1EF3: 09          add     hl,bc                          ; calc entry addr
1EF4: EB          ex      de,hl
1EF5: 3A 00 E0    ld      a,(vblank_tick_e000)
1EF8: E6 01       and     1
1EFA: C6 14       add     a,$14                        ; calc colour
1EFC: 4F          ld      c,a                            ; save
1EFD: 1A          ld      a,(de)
1EFE: 77          ld      (hl),a                         ; tile   [unchecked_address]
1EFF: CB D4       set     2,h
1F01: 71          ld      (hl),c                         ; colour  [video_address]
1F02: CB 94       res     2,h
1F04: E5          push    hl
1F05: 13          inc     de
1F06: 3E 20       ld      a,$20 ; ' '
1F08: DF          rst     hl_plus_equals_a_0018                ; next column
1F09: 1A          ld      a,(de)
1F0A: 77          ld      (hl),a                         ; tile   [unchecked_address]
1F0B: CB D4       set     2,h
1F0D: 71          ld      (hl),c                         ; colour  [video_address]
1F0E: CB 94       res     2,h
1F10: 3E 20       ld      a,$20 ; ' '
1F12: DF          rst     hl_plus_equals_a_0018                ; next column
1F13: 13          inc     de
1F14: 1A          ld      a,(de)
1F15: 77          ld      (hl),a                         ; tile   [unchecked_address]
1F16: CB D4       set     2,h
1F18: 71          ld      (hl),c                         ; colour   [video_address]
1F19: E1          pop     hl
1F1A: 2B          dec     hl                              ; next row
1F1B: DD 74 05    ld      (ix+$05),h
1F1E: DD 75 06    ld      (ix+$06),l                        ; save next row address
1F21: 13          inc     de
1F22: 1A          ld      a,(de)
1F23: 77          ld      (hl),a                         ; tile[unchecked_address]
1F24: CB D4       set     2,h
1F26: 71          ld      (hl),c                         ; colour  [video_address]
1F27: CB 94       res     2,h
1F29: 13          inc     de
1F2A: 3E 20       ld      a,$20 ; ' '
1F2C: DF          rst     hl_plus_equals_a_0018                ; next column
1F2D: 1A          ld      a,(de)
1F2E: 77          ld      (hl),a                         ; tile[unchecked_address]
1F2F: CB D4       set     2,h
1F31: 71          ld      (hl),c                         ; colour  [video_address]
1F32: CB 94       res     2,h
1F34: 13          inc     de
1F35: 3E 20       ld      a,$20 ; ' '
1F37: DF          rst     hl_plus_equals_a_0018                ; next column
1F38: 1A          ld      a,(de)
1F39: 77          ld      (hl),a                         ; tile[unchecked_address]
1F3A: CB D4       set     2,h
1F3C: 71          ld      (hl),c                         ; colour    [video_address]
1F3D: C9          ret
; End of function render_player_bullet_on_fg_1eb7

; ---------------------------------------------------------------------------
; table of bullet tiles (fg layer)
; - 6 tiles used for each bullet
;   - 2^6=64 entries
; ---------------------------------------------------------------------------

update_e200_objects_20be:                                            ; ...
20BE: DD 21 00 E2 ld      ix,e200_obj_tbl_e200
20C2: FD 21 20 EF ld      iy,spriteram_shadow_ef00+0x20     ; set s8.code as base
20C6: 06 09       ld      b,9                           ; 9 objects
20C8: 21 AB E0    ld      hl,spawn_flying_free_slot_threshold_e0ab
20CB: 36 00       ld      (hl),0                        ; reset

loc_20cd:                                                       ; ...
20CD: E5          push    hl
20CE: C5          push    bc
20CF: DD 7E 00    ld      a,(ix+$00)                        ; object state
20D2: A7          and     a                               ; inactive?
20D3: 28 0F       jr      Z,loc_20e4                     ; yes,skip
20D5: 34          inc     (hl)                            ; inc formation free slot threshold
20D6: 21 E4 20    ld      hl,loc_20e4                   ; save return address [push_function]
20D9: E5          push    hl
20DA: 3C          inc     a                               ; active?
20DB: 28 16       jr      Z,update_e200_obj_20f3              ; yes,go
20DD: 3C          inc     a                               ; $FE?
20DE: CA 88 22    jp      Z,loc_2288                     ; yes,go
20E1: C3 CA 22    jp      loc_22ca
; ---------------------------------------------------------------------------

loc_20e4:                                                       ; ...
20E4: C1          pop     bc
20E5: E1          pop     hl
20E6: 11 04 00    ld      de,4                          ; 4 bytes per sprite
20E9: FD 19       add     iy,de                          ; next sprite
20EB: 11 10 00    ld      de,16                         ; 16 bytes per object
20EE: DD 19       add     ix,de                          ; next object
20F0: 10 DB       djnz    loc_20cd                        ; loop
20F2: C9          ret
; ---------------------------------------------------------------------------

update_e200_obj_20f3:                                                ; ...
20F3: CD 2B 24    call    check_sprite_off_screen_242b         ; off-screen?
20F6: DA 90 29    jp      C,deactivate_obj_2990               ; yes,go
20F9: CD DF 29    call    handle_e200_firing_29df
20FC: DD 7E 05    ld      a,(ix+$05)                        ; obj type
20FF: CB 7F       bit     7,a
2101: C2 9D 24    jp      NZ,loc_249d
2104: E6 0F       and     $F
2106: FE 0F       cp      $F                            ; spinning_disc?
2108: 28 1D       jr      Z,update_spinning_disc_2127         ; yes,go
210A: F7          rst    $30		  ; [jump_to_jump_table] [nb_entries=14]
; ---------------------------------------------------------------------------
	.word update_e200_type_0_tumble_ship_255a
	.word update_e200_type_1_plane_2569
	.word update_e200_type_2_ray_2578
	.word update_e200_type_3_butterfly_2587
	.word update_e200_type_4_moth_2599
	.word update_e200_type_56789_25cb
	.word update_e200_type_56789_25cb
	.word update_e200_type_56789_25cb
	.word update_e200_type_56789_25cb
	.word update_e200_type_56789_25cb
	.word update_e200_type_1012_rock_21fb
	.word update_e200_type_1113_rock_2151
	.word update_e200_type_1012_rock_21fb
	.word update_e200_type_1113_rock_2151
; ---------------------------------------------------------------------------

update_spinning_disc_2127:                                           ; ...
2127: CD 3B 24    call    move_object_self_243b
212A: CD 5D 3E    call    upd_spinning_disc_sprite_code_3e5d
212D: FD 36 01 06 ld      (iy+$01),6                       ; sprite colour
2131: C9          ret
; ---------------------------------------------------------------------------
; set japanese symbol sprite code... *** NOT USED *** ???
; - because it is displayed as a spinning_disc
2132: 3A 00 E0    ld      a,(vblank_tick_e000)
2135: 47          ld      b,a
2136: 0F          rrca
2137: E6 03       and     3                              ; calc colour index
2139: 21 4D 21    ld      hl,jap_symbol_sprite_colour_tbl_214d
213C: E7          rst     content_hl_plus_a_0020               ; get entry addr
213D: FD 77 01    ld      (iy+$01),a                        ; sprite colour
2140: 78          ld      a,b
2141: 0F          rrca
2142: 0F          rrca
2143: 0F          rrca
2144: 0F          rrca
2145: E6 01       and     1                              ; calc colour
2147: C6 C4       add     a,$C4 ; '�'                  ; calc sprite code
2149: FD 77 00    ld      (iy+$00),a                        ; sprite code
214C: C9          ret
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------

update_e200_type_1113_rock_2151:                                     ; ...
2151: CD E4 25    call    sub_25e4
2154: CD 3E 25    call    sub_253e
2157: CD 67 24    call    sub_2467
215A: CD A8 28    call    move_object_lookup_28a8
215D: CD 5D 22    call    set_rock_sprite_code_225d
2160: C9          ret
; ---------------------------------------------------------------------------

loc_2161:                                                       ; ...
2161: DD 7E 01    ld      a,(ix+$01)                        ; obj counter
2164: C6 40       add     a,64
2166: DD 77 01    ld      (ix+$01),a                        ; update obj counter
2169: DD 77 02    ld      (ix+$02),a                        ; init obj timer_e025
216C: DD 34 05    inc     (ix+$05)                           ; obj type++
216F: DD 36 0A 00 ld      (ix+$0a),0                     ; dy_dx_lookup table entry
2173: DD 36 06 80 ld      (ix+$06),128                     ; obj dy msb
2177: DD 36 08 20 ld      (ix+$08),32                      ; obj dx msb
217B: CD 91 2A    call    rand_2a91
217E: E6 07       and     7
2180: DD 77 0B    ld      (ix+$0B),a
2183: DD 36 0C 00 ld      (ix+$0C),0
2187: DD 36 0E 20 ld      (ix+$0E),$20 ; ' '
218B: DD 36 0F 00 ld      (ix+$0f),0                     ; aim directly at ship
218F: C9          ret
; ---------------------------------------------------------------------------

move_by_large_alien_dy_dx_2190:                                      ; ...
2190: DD 35 0D    dec     (ix+$0D)
2193: 28 31       jr      Z,loc_21c6
2195: CD 3B 24    call    move_object_self_243b
2198: FD 56 02    ld      d,(iy+$02)                        ; sprite y
219B: DD 5E 03    ld      e,(ix+$03)                        ; obj y lsb
219E: 3A 66 E1    ld      a,(large_alien_obj_tbl_e160+6)      ; large alien dy msb
21A1: 67          ld      h,a
21A2: 3A 67 E1    ld      a,(large_alien_obj_tbl_e160+7)      ; alien dy lsb
21A5: 6F          ld      l,a
21A6: 19          add     hl,de                          ; calc y+dy
21A7: FD 74 02    ld      (iy+$02),h                        ; update sprite y
21AA: DD 75 03    ld      (ix+$03),l                        ; update obj y lsb
21AD: FD 56 03    ld      d,(iy+$03)                        ; sprite x
21B0: DD 5E 04    ld      e,(ix+$04)                        ; obj x lsb
21B3: 3A 68 E1    ld      a,(large_alien_obj_tbl_e160+8)      ; large alien x msb
21B6: 67          ld      h,a
21B7: 3A 69 E1    ld      a,(large_alien_obj_tbl_e160+9)      ; large alien x lsb
21BA: 6F          ld      l,a
21BB: 19          add     hl,de                          ; calc x+dx
21BC: FD 74 03    ld      (iy+$03),h                        ; update sprite x
21BF: DD 75 04    ld      (ix+$04),l                        ; update obj x lsb
21C2: C3 5D 22    jp      set_rock_sprite_code_225d
; ---------------------------------------------------------------------------
21C5: C9          ret
; ---------------------------------------------------------------------------

loc_21c6:                                                       ; ...
21C6: DD 34 0E    inc     (ix+$0E)
21C9: 18 3C       jr      loc_2207
; ---------------------------------------------------------------------------

loc_21cb:                                                       ; ...
21CB: DD 34 05    inc     (ix+$05)                           ; obj type?
21CE: DD 7E 01    ld      a,(ix+$01)                        ; obj counter?
21D1: C6 40       add     a,$40 ; '@'
21D3: DD 77 01    ld      (ix+$01),a
21D6: DD 77 02    ld      (ix+$02),a                        ; int obj timer_e025
21D9: DD 36 0A 0C ld      (ix+$0a),$C
21DD: DD 36 08 FF ld      (ix+$08),-1                      ; init obj dx msb=-1
21E1: CD 98 28    call    lookup_dy_dx_store_2898
21E4: DD 36 06 00 ld      (ix+$06),0                       ; overwrite obj dy msb=0
21E8: E6 07       and     7
21EA: DD 36 0B 07 ld      (ix+$0B),7
21EE: DD 36 0C 00 ld      (ix+$0C),0
21F2: DD 36 0E 20 ld      (ix+$0E),$20 ; ' '
21F6: DD 36 0F 00 ld      (ix+$0f),0                     ; aim directly at ship
21FA: C9          ret
; ---------------------------------------------------------------------------

update_e200_type_1012_rock_21fb:                                     ; ...
21FB: 3A 60 E1    ld      a,(large_alien_obj_tbl_e160)
21FE: 3C          inc     a                               ; active?
21FF: 20 CA       jr      NZ,loc_21cb                    ; no,go
2201: DD 7E 0E    ld      a,(ix+$0E)
2204: A7          and     a
2205: 28 89       jr      Z,move_by_large_alien_dy_dx_2190

loc_2207:                                                       ; ...
2207: 3A CC E0    ld      a,(byte_e0cc)
220A: A7          and     a
220B: CA 61 21    jp      Z,loc_2161
220E: DD 7E 01    ld      a,(ix+$01)                        ; obj counter
2211: C6 02       add     a,2                           ; +=2
2213: DD 77 01    ld      (ix+$01),a                        ; update obj counter
2216: 3A 00 E0    ld      a,(vblank_tick_e000)
2219: 0F          rrca
221A: 0F          rrca
221B: 0F          rrca
221C: 0F          rrca
221D: E6 07       and     7
221F: 21 78 22    ld      hl,byte_2278
2222: E7          rst     content_hl_plus_a_0020
2223: DD 77 0A    ld      (ix+$0a),a                      ; lookup_dy_dx_28cb table entry
2226: CD 98 28    call    lookup_dy_dx_store_2898
2229: 3A CD E0    ld      a,(related_to_big_alien_y_e0cd)
222C: DD 77 0B    ld      (ix+$0B),a
222F: 3A CE E0    ld      a,(related_to_big_alien_x_e0ce)
2232: DD 77 0C    ld      (ix+$0C),a
2235: DD 66 06    ld      h,(ix+$06)
2238: DD 6E 07    ld      l,(ix+$07)                        ; HL=obj dy
223B: 29          add     hl,hl                          ; x2
223C: 29          add     hl,hl                          ; x4
223D: 29          add     hl,hl                          ; x8
223E: 29          add     hl,hl                          ; x16
223F: 29          add     hl,hl                          ; x32
2240: DD 56 0B    ld      d,(ix+$0B)
2243: 1E 00       ld      e,0
2245: 19          add     hl,de                          ; dy x 32 + [$0B].00
2246: FD 74 02    ld      (iy+$02),h                        ; update sprite y
2249: DD 66 08    ld      h,(ix+$08)
224C: DD 6E 09    ld      l,(ix+$09)                        ; HL=obj dx
224F: 29          add     hl,hl                          ; x2
2250: 29          add     hl,hl                          ; x4
2251: 29          add     hl,hl                          ; x8
2252: 29          add     hl,hl                          ; x16
2253: 29          add     hl,hl                          ; x32
2254: DD 56 0C    ld      d,(ix+$0C)
2257: 1E 00       ld      e,0
2259: 19          add     hl,de                          ; dx x 32 + [$0C].00
225A: FD 74 03    ld      (iy+$03),h                        ; update sprite x

; =============== S U B R O U T I N E =======================================


set_rock_sprite_code_225d:                                           ; ...
225D: 3A 00 E0    ld      a,(vblank_tick_e000)
2260: 0F          rrca
2261: 0F          rrca
2262: E6 07       and     7                              ; calc sprite code
2264: 21 80 22    ld      hl,rock_sprite_code_tbl_2280
2267: E7          rst     content_hl_plus_a_0020
2268: FD 77 00    ld      (iy+$00),a                        ; set sprite code
226B: DD 7E 05    ld      a,(ix+$05)                        ; obj type
226E: E6 0F       and     $F
2270: FE 0C       cp      $C                            ; 0-11?
2272: D8          ret     C                               ; yes,exit
2273: FD 36 01 09 ld      (iy+$01),9                       ; set sprite colour
2277: C9          ret
; End of function set_rock_sprite_code_225d

; ---------------------------------------------------------------------------
; lookup dy_dx table entry
; ---------------------------------------------------------------------------

loc_2288:                                                       ; ...
2288: DD 35 0D    dec     (ix+$0D)
228B: C0          ret     NZ
228C: DD 34 00    inc     (ix+$00)                           ; state++
228F: C9          ret
; ---------------------------------------------------------------------------

loc_2290:                                                       ; ...
2290: DD 7E 0A    ld      a,(ix+$0a)
2293: 3C          inc     a
2294: C2 90 29    jp      NZ,deactivate_obj_2990
2297: DD 7E 02    ld      a,(ix+$02)                        ; obj timer_e025
229A: FE 3C       cp      $3C ; '<'
229C: 28 0A       jr      Z,loc_22a8
229E: DD 35 02    dec     (ix+$02)
22A1: CA 90 29    jp      Z,deactivate_obj_2990
22A4: CD 6F 29    call    scroll_airborne_object_with_gnd_296f
22A7: C9          ret
; ---------------------------------------------------------------------------

loc_22a8:                                                       ; ...
22A8: DD 7E 01    ld      a,(ix+$01)                        ; obj counter
22AB: 21 BA 22    ld      hl,some_bonus_score_sprite_code_tbl_22ba
22AE: E7          rst     content_hl_plus_a_0020
22AF: FD 77 00    ld      (iy+$00),a                        ; sprite code
22B2: FD 36 01 00 ld      (iy+$01),0                       ; sprite colour
22B6: DD 35 02    dec     (ix+$02)                           ; obj timer_e025 -= 2
22B9: C9          ret
; ---------------------------------------------------------------------------
22BA:                                                     ; '100'
; ---------------------------------------------------------------------------

loc_22ca:                                                       ; ...
22CA: DD 7E 00    ld      a,(ix+$00)                        ; obj state
22CD: 3D          dec     a                               ; 1?
22CE: CA 90 22    jp      Z,loc_2290                     ; yes,go
22D1: FE 3E       cp      $3E ; '>'
22D3: 30 29       jr      NC,loc_22fe
22D5: DD 35 00    dec     (ix+$00)                           ; obj state--
22D8: E6 03       and     3
22DA: 20 03       jr      NZ,loc_22df
22DC: FD 34 00    inc     (iy+$00)                           ; sprite code++

loc_22df:                                                       ; ...
22DF: C3 6F 29    jp      scroll_airborne_object_with_gnd_296f
; ---------------------------------------------------------------------------

award_extra_life_for_spinning_disc_22e2:                             ; ...
22E2: DD 36 01 0F ld      (ix+$01),$F                     ; init obj counter
22E6: DD 36 02 3C ld      (ix+$02),$3C ; '<'              ; init obj timer_e025
22EA: DD 36 00 01 ld      (ix+$00),1                       ; obj state=1
22EE: DD 36 0A FF ld      (ix+$0a),$FF                  ; obj dy_dx_lookyp table entry = invalid?
22F2: 21 00 E5    ld      hl,curr_lives_left_e500
22F5: 34          inc     (hl)                            ; extra life
22F6: CD 28 47    call    snd_cmd_01_4728
22F9: 11 00 09    ld      de,$900                      ; show lives ships
22FC: FF          rst     add_fn_to_q_0038
22FD: C9          ret
; ---------------------------------------------------------------------------

loc_22fe:                                                       ; ...
22FE: DD 7E 05    ld      a,(ix+$05)                        ; obj type
2301: E6 0F       and     $F                            ; spinning_disc?
2303: FE 0F       cp      $F                            ; yes,go
2305: 28 DB       jr      Z,award_extra_life_for_spinning_disc_22e2
2307: FE 0A       cp      $A                            ; rock?
2309: D2 C1 23    jp      NC,loc_23c1                    ; no,go
230C: 3E 24       ld      a,$24 ; '$'
230E: DD 77 00    ld      (ix+$00),a                        ; obj state=
2311: FD 36 00 20 ld      (iy+$00),$20 ; ' '              ; sprite code=explosion
2315: FD 36 01 00 ld      (iy+$01),0                       ; sprite colour
2319: CD 38 47    call    snd_cmd_04_4738
231C: DD 7E 0A    ld      a,(ix+$0a)
231F: 3C          inc     a
2320: 28 48       jr      Z,loc_236a
2322: DD 7E 05    ld      a,(ix+$05)                        ; obj type
2325: E6 0F       and     $F
2327: FE 05       cp      5                              ; formation alien?
2329: 30 06       jr      NC,check_formation_destroyed_1_2331 ; yes,go

loc_232b:                                                       ; ...
232B: 11 00 08    ld      de,$800                      ; add (50 pts) to score,update hi
232E: C3 38 00    jp      add_fn_to_q_0038
; ---------------------------------------------------------------------------

check_formation_destroyed_1_2331:                                    ; ...
2331: 3A C7 E0    ld      a,(formation_cnt_e0c7)
2334: 3D          dec     a
2335: 32 C7 E0    ld      (formation_cnt_e0c7),a
2338: FD 36 01 05 ld      (iy+$01),5                       ; sprite colour
233C: 20 ED       jr      NZ,loc_232b
233E: DD 7E 05    ld      a,(ix+$05)                        ; obj type
2341: E6 0F       and     $F
2343: FE 09       cp      9                              ; spinning_disc?
2345: 28 6A       jr      Z,award_extra_life_for_formation_23b1 ; yes,go
2347: DD 36 02 3C ld      (ix+$02),$3C ; '<'              ; obj timer_e025
234B: DD 36 0A FF ld      (ix+$0a),$FF                  ; obj dy_dx_lookup table entry = invalid?
234F: 21 C8 E0    ld      hl,formations_destroyed_cnt_e0c8
2352: 7E          ld      a,(hl)                         ; get count
2353: 34          inc     (hl)                            ; ++
2354: FE 0A       cp      10                             ; exceeded max?
2356: 38 02       jr      C,loc_235a                     ; no,skip
2358: 3E 09       ld      a,9                           ; use max

loc_235a:                                                       ; ...
235A: 21 01 24    ld      hl,formation_pts_tbl_2401
235D: 87          add     a,a                            ; calc entry offset
235E: E7          rst     content_hl_plus_a_0020
235F: 5F          ld      e,a                            ; points entry
2360: 16 08       ld      d,8                           ; add to score and update hi
2362: 23          inc     hl                              ; next byte in table
2363: 7E          ld      a,(hl)                         ; get byte
2364: DD 77 01    ld      (ix+$01),a                        ; update obj counter
2367: C3 38 00    jp      add_fn_to_q_0038
; ---------------------------------------------------------------------------

loc_236a:                                                       ; ...
236A: DD 7E 05    ld      a,(ix+$05)                        ; obj type
236D: E6 0F       and     $F
236F: FE 05       cp      5                              ; formation alien?
2371: D4 87 23    call    NC,check_formation_destroyed_2_2387 ; yes,call
2374: DD 7E 01    ld      a,(ix+$01)                        ; obj counter?
2377: 21 15 24    ld      hl,byte_2415
237A: 87          add     a,a
237B: E7          rst     content_hl_plus_a_0020
237C: 5F          ld      e,a
237D: 16 08       ld      d,8                           ; add to score & update hi
237F: 23          inc     hl
2380: 7E          ld      a,(hl)
2381: DD 77 01    ld      (ix+$01),a                        ; obj counter?
2384: C3 38 00    jp      add_fn_to_q_0038

; =============== S U B R O U T I N E =======================================


check_formation_destroyed_2_2387:                                    ; ...
2387: 3A C7 E0    ld      a,(formation_cnt_e0c7)
238A: 3D          dec     a
238B: 32 C7 E0    ld      (formation_cnt_e0c7),a
238E: FD 36 01 05 ld      (iy+$01),5                       ; sprite colour
2392: C0          ret     NZ
2393: DD 7E 05    ld      a,(ix+$05)                        ; obj type
2396: E6 0F       and     $F
2398: FE 09       cp      9                              ; spinning_disc?
239A: 28 15       jr      Z,award_extra_life_for_formation_23b1 ; yes,go
239C: 21 C8 E0    ld      hl,formations_destroyed_cnt_e0c8
239F: 7E          ld      a,(hl)                         ; formation count
; technically,this could wrap,but would require you
; to destroy 256 formations without dying..
23A0: 34          inc     (hl)                            ; ++
23A1: FE 0A       cp      10                             ; max exceeded?
23A3: 38 02       jr      C,loc_23a7                     ; yes,skip
23A5: 3E 09       ld      a,9                           ; use max

loc_23a7:                                                       ; ...
23A7: 21 01 24    ld      hl,formation_pts_tbl_2401
23AA: 87          add     a,a                            ; calc entry offset
23AB: E7          rst     content_hl_plus_a_0020
23AC: 5F          ld      e,a                            ; points_tbl_0753 entry
23AD: 16 08       ld      d,8                           ; add to score,update hi
23AF: FF          rst     add_fn_to_q_0038
23B0: C9          ret
; ---------------------------------------------------------------------------
; destroying a formation of spinning_discs!

award_extra_life_for_formation_23b1:                                 ; ...
23B1: DD 36 0A 00 ld      (ix+$0a),0
23B5: 21 00 E5    ld      hl,curr_lives_left_e500
23B8: 34          inc     (hl)                            ; extra life
23B9: CD 28 47    call    snd_cmd_01_4728
23BC: 11 00 09    ld      de,$900                      ; show lives ships
23BF: FF          rst     add_fn_to_q_0038
23C0: C9          ret
; End of function check_formation_destroyed_2_2387

; ---------------------------------------------------------------------------

loc_23c1:                                                       ; ...
23C1: DD 7E 0A    ld      a,(ix+$0a)
23C4: 3C          inc     a
23C5: 20 07       jr      NZ,loc_23ce
23C7: 3E 3F       ld      a,$3F ; '?'
23C9: 32 50 E1    ld      (bomb_obj_e150),a                   ; obj state
23CC: 18 19       jr      explode_and_add_50_pts_23e7
; ---------------------------------------------------------------------------

loc_23ce:                                                       ; ...
23CE: DD 7E 05    ld      a,(ix+$05)                        ; obj type
23D1: FE 0C       cp      $C                            ; rock 12/13?
23D3: 30 12       jr      NC,explode_and_add_50_pts_23e7      ; yes,go
23D5: C6 02       add     a,2                           ; ???
23D7: DD 77 05    ld      (ix+$05),a                        ; update obj type
23DA: DD 36 00 FF ld      (ix+$00),$FF                    ; obj state=active?
23DE: CD 7D 47    call    snd_cmd_03_477d
23E1: 16 08       ld      d,8                           ; add to score,update hi
23E3: 1E 00       ld      e,0                           ; 50 pts
23E5: FF          rst     add_fn_to_q_0038
23E6: C9          ret
; ---------------------------------------------------------------------------

explode_and_add_50_pts_23e7:                                         ; ...
23E7: 3E 24       ld      a,$24 ; '$'
23E9: DD 77 00    ld      (ix+$00),a                        ; obj state=?
23EC: DD 36 0A 00 ld      (ix+$0a),0                     ; obj dy_dx_lookup table entry
23F0: FD 36 00 20 ld      (iy+$00),$20 ; ' '              ; sprite code=explosion
23F4: FD 36 01 00 ld      (iy+$01),0                       ; sprite colour
23F8: CD 38 47    call    snd_cmd_04_4738
23FB: 16 08       ld      d,8                           ; add to score update hi
23FD: 1E 00       ld      e,0                           ; 50 pts
23FF: FF          rst     add_fn_to_q_0038
2400: C9          ret
; ---------------------------------------------------------------------------
; table of points each time you destroy a formation
; - starts at 500,incrases by 500 up to 5,000 pts
; - 1st byte is points_tbl_0753 entry
; - 2nd byte written to obj counter...?
; table of points,obj counter??

; =============== S U B R O U T I N E =======================================


check_sprite_off_screen_242b:                                        ; ...
242B: FD 7E 02    ld      a,(iy+$02)                        ; sprite y
242E: C6 03       add     a,3
2430: FE 07       cp      7                              ; off-screen?
2432: D8          ret     C                               ; yes,exit
2433: FD 7E 03    ld      a,(iy+$03)                        ; sprite x
2436: C6 04       add     a,4
2438: FE 03       cp      3                              ; off-screen?
243A: C9          ret                                     ; C=yes
; End of function check_sprite_off_screen_242b


; =============== S U B R O U T I N E =======================================


move_object_self_243b:                                               ; ...
243B: DD 56 06    ld      d,(ix+$06)                        ; obj dy msb
243E: DD 5E 07    ld      e,(ix+$07)                        ; obj dy lsb
2441: FD 66 02    ld      h,(iy+$02)                        ; sn.y
2444: DD 6E 03    ld      l,(ix+$03)                        ; obj y lsb
2447: 19          add     hl,de                          ; calc y+dy
2448: EB          ex      de,hl
2449: 2A 09 E1    ld      hl,(airborne_dy_e109)
244C: 19          add     hl,de                          ; move w/bg
244D: FD 74 02    ld      (iy+$02),h                        ; update sn.y
2450: DD 75 03    ld      (ix+$03),l                        ; update obj y lsb
2453: DD 56 08    ld      d,(ix+$08)                        ; obj dx msb
2456: DD 5E 09    ld      e,(ix+$09)                        ; obj dx lsb
2459: FD 66 03    ld      h,(iy+$03)                        ; sn.x
245C: DD 6E 04    ld      l,(ix+$04)                        ; obj x lsb
245F: 19          add     hl,de                          ; calc x+dx
2460: FD 74 03    ld      (iy+$03),h                        ; update sn.x
2463: DD 75 04    ld      (ix+$04),l                        ; update obj x lsb
2466: C9          ret
; End of function move_object_self_243b


; =============== S U B R O U T I N E =======================================


sub_2467:                                                       ; ...
2467: DD 56 01    ld      d,(ix+$01)                        ; obj counter
246A: DD 5E 09    ld      e,(ix+$09)                        ; obj dx lsb
246D: DD 6E 06    ld      l,(ix+$06)                        ; obj dy msb
2470: 26 00       ld      h,0
2472: 29          add     hl,hl                          ; dy msb x2
2473: 29          add     hl,hl                          ; dy msb x4
2474: EB          ex      de,hl                          ; HL=counter,dx lsb DE=dy msb x4
2475: DD 7E 02    ld      a,(ix+$02)                        ; obj timer_e025
2478: 94          sub     h                               ; sub obj counter
2479: 47          ld      b,a                            ; save
247A: C6 02       add     a,2
247C: FE 05       cp      5                              ; time to ?
247E: 38 0E       jr      C,loc_248e
2480: CB 78       bit     7,b                            ; time to ?
2482: 28 11       jr      Z,loc_2495
2484: A7          and     a
2485: ED 52       sbc     hl,de
2487: DD 74 01    ld      (ix+$01),h                        ; update obj counter
248A: DD 75 09    ld      (ix+$09),l                        ; update obj dx lsb
248D: C9          ret
; ---------------------------------------------------------------------------

loc_248e:                                                       ; ...
248E: DD 7E 02    ld      a,(ix+$02)                        ; timer_e025
2491: DD 77 01    ld      (ix+$01),a                        ; init counter
2494: C9          ret
; ---------------------------------------------------------------------------

loc_2495:                                                       ; ...
2495: 19          add     hl,de
2496: DD 74 01    ld      (ix+$01),h
2499: DD 75 09    ld      (ix+$09),l                        ; update obj dx lsb
249C: C9          ret
; End of function sub_2467

; ---------------------------------------------------------------------------

loc_249d:                                                       ; ...
249D: DD 7E 0D    ld      a,(ix+$0D)
24A0: A7          and     a
24A1: CC AE 24    call    Z,sub_24ae
24A4: DD 35 0D    dec     (ix+$0D)
24A7: CD 3B 24    call    move_object_self_243b
24AA: CD 13 27    call    animate_e200_object_sprite_2713
24AD: C9          ret

; =============== S U B R O U T I N E =======================================


sub_24ae:                                                       ; ...
24AE: 21 2C 34    ld      hl,off_342c
24B1: DD 7E 0B    ld      a,(ix+$0B)
24B4: EF          rst     de_eq_contents_hl_plus_2a_0028
24B5: EB          ex      de,hl
24B6: DD 7E 0C    ld      a,(ix+$0C)
24B9: DD 34 0C    inc     (ix+$0C)
24BC: 87          add     a,a
24BD: E7          rst     content_hl_plus_a_0020
24BE: FE FF       cp      $FF
24C0: 28 0C       jr      Z,loc_24ce
24C2: DD 77 01    ld      (ix+$01),a
24C5: 23          inc     hl
24C6: 7E          ld      a,(hl)
24C7: DD 77 0D    ld      (ix+$0D),a
24CA: CD 98 28    call    lookup_dy_dx_store_2898
24CD: C9          ret
; ---------------------------------------------------------------------------

loc_24ce:                                                       ; ...
24CE: 23          inc     hl
24CF: 7E          ld      a,(hl)
24D0: FE FF       cp      $FF
24D2: 28 14       jr      Z,loc_24e8
24D4: DD 77 0D    ld      (ix+$0D),a
24D7: DD 36 06 00 ld      (ix+$06),0
24DB: DD 36 07 00 ld      (ix+$07),0
24DF: DD 36 08 00 ld      (ix+$08),0
24E3: DD 36 09 00 ld      (ix+$09),0
24E7: C9          ret
; ---------------------------------------------------------------------------

loc_24e8:                                                       ; ...
24E8: E1          pop     hl			; [pop_address]
24E9: DD CB 05 BE res     7,(ix+$05)
24ED: DD 7E 05    ld      a,(ix+$05)                        ; obj type
24F0: 0F          rrca
24F1: 0F          rrca
24F2: 0F          rrca
24F3: 0F          rrca
24F4: E6 03       and     3
24F6: F7          rst    $30	  ; [jump_to_jump_table] [nb_entries=4]
; End of function sub_24ae

; ---------------------------------------------------------------------------
	.word loc_2505
	.word loc_24ff
	.word loc_250c
	.word loc_2521
; ---------------------------------------------------------------------------

loc_24ff:                                                       ; ...
24FF: CD 9C 6A    call    aim_near_ship_6a9c
2502: DD 77 01    ld      (ix+$01),a

loc_2505:                                                       ; ...
2505: DD 36 0A 08 ld      (ix+$0a),8
2509: C3 98 28    jp      lookup_dy_dx_store_2898
; ---------------------------------------------------------------------------

loc_250c:                                                       ; ...
250C: DD 36 06 60 ld      (ix+$06),$60 ; '`'
2510: DD 36 08 00 ld      (ix+$08),0
2514: DD 36 0A 06 ld      (ix+$0a),6
2518: DD 36 0E 18 ld      (ix+$0E),$18
251C: DD 36 0F 00 ld      (ix+$0f),0                     ; aim directly at ship
2520: C9          ret
; ---------------------------------------------------------------------------

loc_2521:                                                       ; ...
2521: DD 7E 01    ld      a,(ix+$01)
2524: C6 80       add     a,$80 ; '�'
2526: DD 77 02    ld      (ix+$02),a
2529: DD 36 06 50 ld      (ix+$06),$50 ; 'P'
252D: DD 36 08 FF ld      (ix+$08),$FF
2531: DD 36 0A 03 ld      (ix+$0a),3
2535: DD 36 0E FF ld      (ix+$0E),$FF
2539: DD 36 0F 00 ld      (ix+$0f),0                     ; aim directly at ship
253D: C9          ret

; =============== S U B R O U T I N E =======================================


sub_253e:                                                       ; ...
253E: DD CB 05 76 bit     6,(ix+$05)
2542: C0          ret     NZ
2543: DD 7E 08    ld      a,(ix+$08)                        ; obj dx
2546: A7          and     a                               ; zero?
2547: 28 04       jr      Z,loc_254d                     ; yes,go
2549: DD 35 08    dec     (ix+$08)                           ; dx--
254C: C9          ret
; ---------------------------------------------------------------------------

loc_254d:                                                       ; ...
254D: DD 7E 0E    ld      a,(ix+$0E)
2550: DD 77 08    ld      (ix+$08),a                        ; update dx
2553: CD 9C 6A    call    aim_near_ship_6a9c
2556: DD 77 02    ld      (ix+$02),a
2559: C9          ret
; End of function sub_253e

; ---------------------------------------------------------------------------

update_e200_type_0_tumble_ship_255a:                                 ; ...
255A: CD E4 25    call    sub_25e4
; START OF FUNCTION CHUNK FOR sub_25a2
255D: CD E0 26    call    sub_26e0
2560: CD 67 24    call    sub_2467
2563: CD A8 28    call    move_object_lookup_28a8
2566: C3 13 27    jp      animate_e200_object_sprite_2713
; END OF FUNCTION CHUNK FOR sub_25a2
; ---------------------------------------------------------------------------

update_e200_type_1_plane_2569:                                       ; ...
2569: CD E4 25    call    sub_25e4
256C: CD 3E 25    call    sub_253e
256F: CD 67 24    call    sub_2467
2572: CD A8 28    call    move_object_lookup_28a8
2575: C3 13 27    jp      animate_e200_object_sprite_2713
; ---------------------------------------------------------------------------

update_e200_type_2_ray_2578:                                         ; ...
2578: CD E4 25    call    sub_25e4
257B: CD 3E 25    call    sub_253e
257E: CD 67 24    call    sub_2467
2581: CD A8 28    call    move_object_lookup_28a8
2584: C3 13 27    jp      animate_e200_object_sprite_2713
; ---------------------------------------------------------------------------

update_e200_type_3_butterfly_2587:                                   ; ...
2587: CD E4 25    call    sub_25e4
258A: CD 3E 25    call    sub_253e
258D: CD 67 24    call    sub_2467
2590: CD B0 26    call    sub_26b0
2593: CD A8 28    call    move_object_lookup_28a8
2596: C3 13 27    jp      animate_e200_object_sprite_2713
; ---------------------------------------------------------------------------

update_e200_type_4_moth_2599:                                        ; ...
2599: CD E4 25    call    sub_25e4
259C: CD A2 25    call    sub_25a2
259F: C3 13 27    jp      animate_e200_object_sprite_2713

; =============== S U B R O U T I N E =======================================


sub_25a2:                                                       ; ...

; FUNCTION CHUNK AT ROM:255D SIZE 0000000C BYTES

25A2: DD 7E 0C    ld      a,(ix+$0C)
25A5: E6 03       and     3
25A7: F7          rst    $30		  ; [jump_to_jump_table] [nb_entries=4]
; End of function sub_25a2

; ---------------------------------------------------------------------------
	.word loc_25be
	.word move_object_lookup_28a8
	.word loc_25b0
	.word move_object_lookup_28a8
; ---------------------------------------------------------------------------

loc_25b0:                                                       ; ...
25B0: 3A 00 E0    ld      a,(vblank_tick_e000)
25B3: E6 07       and     7                              ; time to ???
25B5: CC C4 25    call    Z,sub_25c4
25B8: CD 67 24    call    sub_2467
25BB: C3 6F 29    jp      scroll_airborne_object_with_gnd_296f
; ---------------------------------------------------------------------------

loc_25be:                                                       ; ...
25BE: CD 67 24    call    sub_2467
25C1: C3 A8 28    jp      move_object_lookup_28a8

; =============== S U B R O U T I N E =======================================


sub_25c4:                                                       ; ...
25C4: CD 9C 6A    call    aim_near_ship_6a9c
25C7: DD 77 02    ld      (ix+$02),a
25CA: C9          ret
; End of function sub_25c4

; ---------------------------------------------------------------------------

update_e200_type_56789_25cb:                                         ; ...
25CB: CD D2 25    call    sub_25d2
25CE: CD 13 27    call    animate_e200_object_sprite_2713
25D1: C9          ret

; =============== S U B R O U T I N E =======================================


sub_25d2:                                                       ; ...
25D2: DD CB 05 6E bit     5,(ix+$05)                        ; type flag=?
25D6: 20 03       jr      NZ,loc_25db
25D8: C3 3B 24    jp      move_object_self_243b
; ---------------------------------------------------------------------------

loc_25db:                                                       ; ...
25DB: CD 3E 25    call    sub_253e
25DE: CD 67 24    call    sub_2467
25E1: C3 A8 28    jp      move_object_lookup_28a8
; End of function sub_25d2


; =============== S U B R O U T I N E =======================================


sub_25e4:                                                       ; ...
25E4: DD CB 05 76 bit     6,(ix+$05)
25E8: C0          ret     NZ

loc_25e9:
25E9: DD 7E 0D    ld      a,(ix+$0D)
25EC: A7          and     a
25ED: CC 27 26    call    Z,sub_2627
25F0: DD 35 0D    dec     (ix+$0D)
25F3: C9          ret
; End of function sub_25e4

; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR sub_2627

something_for_moth_25f4:                                             ; ...
25F4: DD 7E 0C    ld      a,(ix+$0C)
25F7: DD 34 0C    inc     (ix+$0C)
25FA: DD 36 0D 30 ld      (ix+$0D),$30 ; '0'
25FE: E6 03       and     3
2600: F7          rst    $30	  ; [jump_to_jump_table] [nb_entries=4]
; ---------------------------------------------------------------------------
	.word locret_2609
	.word loc_260a
	.word loc_260f
	.word loc_2618
; ---------------------------------------------------------------------------

locret_2609:                                                    ; ...
2609: C9          ret
; ---------------------------------------------------------------------------

loc_260a:                                                       ; ...
260A: DD 36 0D 20 ld      (ix+$0D),$20 ; ' '
260E: C9          ret
; END OF FUNCTION CHUNK FOR sub_2627
; ---------------------------------------------------------------------------

loc_260f:                                                       ; ...
260F: DD 36 0F 00 ld      (ix+$0f),0                     ; aim directly at ship
2613: DD 36 0A 0C ld      (ix+$0a),$C
2617: C9          ret
; ---------------------------------------------------------------------------

loc_2618:                                                       ; ...
2618: DD 36 0F 09 ld      (ix+$0f),9                     ; obj aiming entry
261C: CD 9C 6A    call    aim_near_ship_6a9c
261F: DD 77 02    ld      (ix+$02),a
2622: DD 36 0A 04 ld      (ix+$0a),4
2626: C9          ret

; =============== S U B R O U T I N E =======================================


sub_2627:                                                       ; ...

; FUNCTION CHUNK AT ROM:25F4 SIZE 0000001B BYTES

2627: DD 7E 05    ld      a,(ix+$05)                        ; obj type
262A: E6 0F       and     $F
262C: FE 04       cp      4                              ; moth?
262E: 28 C4       jr      Z,something_for_moth_25f4           ; yes,go
2630: 21 6E 26    ld      hl,off_266e
2633: DD 7E 0B    ld      a,(ix+$0B)                      ; offset of table
2636: EF          rst     de_eq_contents_hl_plus_2a_0028       ; addr of aiming entries table
2637: EB          ex      de,hl
2638: DD 7E 0C    ld      a,(ix+$0C)                      ; aiming table entry offset
263B: DD 34 0C    inc     (ix+$0C)                         ; ++
263E: E7          rst     content_hl_plus_a_0020
263F: 47          ld      b,a                            ; save entry
2640: FE FF       cp      $FF
2642: 28 21       jr      Z,loc_2665
2644: FE FE       cp      $FE ; '�'
2646: 28 14       jr      Z,loc_265c
2648: 0F          rrca
2649: 0F          rrca
264A: 0F          rrca
264B: 0F          rrca
264C: E6 F0       and     $F0 ; '�'                     ; lo->hi nibble
264E: DD 77 0D    ld      (ix+$0D),a
2651: 78          ld      a,b
2652: 0F          rrca
2653: 0F          rrca
2654: 0F          rrca
2655: 0F          rrca                                    ; hi->lo nibble
2656: E6 0F       and     $F
2658: DD 77 0F    ld      (ix+$0f),a                      ; obj aiming entry
265B: C9          ret
; ---------------------------------------------------------------------------

loc_265c:                                                       ; ...
265C: DD CB 05 F6 set     6,(ix+$05)
2660: DD 36 0D FF ld      (ix+$0D),$FF
2664: C9          ret
; ---------------------------------------------------------------------------

loc_2665:                                                       ; ...
2665: DD CB 05 F6 set     6,(ix+$05)
2669: DD 36 0D FF ld      (ix+$0D),$FF
266D: C9          ret
; End of function sub_2627

; ---------------------------------------------------------------------------
; hi nibble is aiming table entry
; lo nibble -> $0D
;	.word byte_267e                           ; ...
;	.word byte_2685
;	.word byte_268c
;	.word byte_2693
;	.word byte_269a
;	.word byte_26a1
;	.word byte_26a8
;	.word byte_26af

; =============== S U B R O U T I N E =======================================


sub_26b0:                                                       ; ...
26B0: 3A 00 E0    ld      a,(vblank_tick_e000)
26B3: E6 07       and     7
26B5: C0          ret     NZ
26B6: DD 7E 02    ld      a,(ix+$02)                        ; obj timer_e025
26B9: DD 96 01    sub     (ix+$01)                           ; obj counter
26BC: 47          ld      b,a
26BD: C6 06       add     a,6
26BF: FE 0D       cp      $D                            ; time to ???
26C1: 38 13       jr      C,loc_26d6
26C3: 78          ld      a,b
26C4: C6 0C       add     a,$C
26C6: FE 30       cp      $30 ; '0'                     ; time to ???
26C8: D8          ret     C
26C9: DD 7E 0A    ld      a,(ix+$0a)
26CC: FE 06       cp      6                              ; time to ???
26CE: D8          ret     C
26CF: DD 35 0A    dec     (ix+$0a)
26D2: DD 35 0A    dec     (ix+$0a)
26D5: C9          ret
; ---------------------------------------------------------------------------

loc_26d6:                                                       ; ...
26D6: DD 7E 0A    ld      a,(ix+$0a)
26D9: FE 0C       cp      $C
26DB: D0          ret     NC
26DC: DD 34 0A    inc     (ix+$0a)
26DF: C9          ret
; End of function sub_26b0


; =============== S U B R O U T I N E =======================================


sub_26e0:                                                       ; ...
26E0: DD CB 05 76 bit     6,(ix+$05)
26E4: C0          ret     NZ
26E5: DD 7E 08    ld      a,(ix+$08)                        ; obj dx msb
26E8: A7          and     a                               ; zero?
26E9: CC F0 26    call    Z,loc_26f0                     ; yes,call
26EC: DD 35 08    dec     (ix+$08)                           ; obj dx msb--
26EF: C9          ret
; End of function sub_26e0

; ---------------------------------------------------------------------------

loc_26f0:                                                       ; ...
26F0: CD 9C 6A    call    aim_near_ship_6a9c
26F3: DD 77 02    ld      (ix+$02),a                        ; obj timer_e025
26F6: 0E 20       ld      c,$20 ; ' '
26F8: E6 80       and     $80 ; '�'
26FA: 47          ld      b,a
26FB: DD 7E 01    ld      a,(ix+$01)                        ; obj counter
26FE: E6 80       and     $80 ; '�'
2700: A8          xor     b
2701: DD 77 07    ld      (ix+$07),a                        ; obj dy lsb
2704: A7          and     a
2705: 20 07       jr      NZ,loc_270e
2707: DD 7E 0E    ld      a,(ix+$0E)
270A: DD 77 08    ld      (ix+$08),a                        ; obj dx msb
270D: C9          ret
; ---------------------------------------------------------------------------

loc_270e:                                                       ; ...
270E: DD 36 08 40 ld      (ix+$08),$40 ; '@'              ; obj dx msb
2712: C9          ret

; =============== S U B R O U T I N E =======================================


animate_e200_object_sprite_2713:                                     ; ...
2713: DD 7E 05    ld      a,(ix+$05)                        ; obj type
2716: E6 0F       and     $F
2718: F7          rst    $30	  ; [jump_to_jump_table] [nb_entries=10]
; End of function animate_e200_object_sprite_2713

; ---------------------------------------------------------------------------
	.word animate_tumble_ship_272d
	.word animate_plane_27cb
	.word animate_ray_27e0
	.word animate_butterfly_2802
	.word animate_moth_2817
	.word animate_bug_283f
	.word animate_turtle_2869
	.word animate_pincer_bug_2872
	.word animate_star_287b
	.word animate_spinning_disc_2884
; ---------------------------------------------------------------------------

animate_tumble_ship_272d:                                            ; ...
272D: DD CB 07 7E bit     7,(ix+$07)
2731: 20 1A       jr      NZ,loc_274d
2733: DD 7E 02    ld      a,(ix+$02)                        ; timer_e025?
2736: C6 10       add     a,$10
2738: 0F          rrca
2739: 0F          rrca
273A: 0F          rrca
273B: 0F          rrca
273C: E6 0F       and     $F
273E: 21 7B 27    ld      hl,tumble_ship_sprite_code_tbl_3_277b
2741: EF          rst     de_eq_contents_hl_plus_2a_0028
2742: EB          ex      de,hl
2743: DD 7E 08    ld      a,(ix+$08)                        ; obj dx msb
2746: 0F          rrca
2747: 0F          rrca
2748: E6 07       and     7
274A: E7          rst     content_hl_plus_a_0020
274B: 18 16       jr      set_sprite_code_colour_2763
; ---------------------------------------------------------------------------

loc_274d:                                                       ; ...
274D: 21 6B 27    ld      hl,tumble_ship_sprite_code_tbl_1_276b
2750: DD 7E 02    ld      a,(ix+$02)
2753: E6 80       and     $80 ; '�'
2755: 28 03       jr      Z,loc_275a
2757: 21 73 27    ld      hl,tumble_ship_sprite_code_tbl_2_2773

loc_275a:                                                       ; ...
275A: DD 7E 08    ld      a,(ix+$08)
275D: 0F          rrca
275E: 0F          rrca
275F: 0F          rrca
2760: E6 07       and     7                              ; calc code
2762: E7          rst     content_hl_plus_a_0020               ; code entry addr

set_sprite_code_colour_2763:                                         ; ...
2763: FD 77 00    ld      (iy+$00),a                        ; set code
2766: FD 36 01 00 ld      (iy+$01),0                       ; set colour
276A: C9          ret
; ---------------------------------------------------------------------------
;	.word byte_27a3                     ; ...
;	.word byte_27a3
;	.word byte_27a3
;	.word byte_279b
;	.word byte_279b
;	.word byte_27ab
;	.word byte_27ab
;	.word byte_27ab
;	.word byte_27bb
;	.word byte_27bb
;	.word byte_27bb
;	.word byte_27b3
;	.word byte_27b3
;	.word byte_27c3
;	.word byte_27c3
;	.word byte_27c3
; ---------------------------------------------------------------------------

animate_plane_27cb:                                                  ; ...
27CB: 21 D0 27    ld      hl,place_sprite_tbl_27d0
27CE: 18 13       jr      set_16_sprite_code_colour_27e3
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------

animate_ray_27e0:                                                    ; ...
27E0: 21 F2 27    ld      hl,ray_sprite_code_tbl_27f2

set_16_sprite_code_colour_27e3:                                      ; ...
27E3: DD 7E 01    ld      a,(ix+$01)
27E6: C6 08       add     a,8
27E8: 0F          rrca
27E9: 0F          rrca
27EA: 0F          rrca
27EB: 0F          rrca
27EC: E6 0F       and     $F                            ; calc sprite code
27EE: E7          rst     content_hl_plus_a_0020
27EF: C3 63 27    jp      set_sprite_code_colour_2763
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------

animate_butterfly_2802:                                              ; ...
2802: 21 07 28    ld      hl,butterfly_sprite_code_tbl_2807
2805: 18 DC       jr      set_16_sprite_code_colour_27e3
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------

animate_moth_2817:                                                   ; ...
2817: 21 1C 28    ld      hl,moth_sprite_code_tbl_281c
281A: 18 C7       jr      set_16_sprite_code_colour_27e3
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; *** UNUSED???
282C: 3A 00 E0    ld      a,(vblank_tick_e000)
282F: 0F          rrca
2830: 0F          rrca
2831: E6 07       and     7
2833: E7          rst     content_hl_plus_a_0020
2834: C3 63 27    jp      set_sprite_code_colour_2763
; ---------------------------------------------------------------------------
; *** UNUSED???
; ---------------------------------------------------------------------------

animate_bug_283f:                                                    ; ...
283F: 21 5D 28    ld      hl,bug_sprite_code_tbl_285d

set_4_sprite_code_colour_2842:                                       ; ...
2842: DD 7E 01    ld      a,(ix+$01)
2845: C6 10       add     a,$10
2847: 07          rlca
2848: 07          rlca
2849: 07          rlca
284A: E6 03       and     3                              ; calc sprite code
284C: E7          rst     content_hl_plus_a_0020
284D: FD 77 00    ld      (iy+$00),a                        ; set sprite code
2850: 3A 00 E0    ld      a,(vblank_tick_e000)
2853: E6 07       and     7                              ; calc colour
2855: 21 61 28    ld      hl,bug_tutle_pincer_bug_sprite_colour_tbl_2861
2858: E7          rst     content_hl_plus_a_0020               ; get entry addr
2859: FD 77 01    ld      (iy+$01),a                        ; set sprite colour
285C: C9          ret
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------

animate_turtle_2869:                                                 ; ...
2869: 21 6E 28    ld      hl,turtle_sprite_code_tbl_286e
286C: 18 D4       jr      set_4_sprite_code_colour_2842
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------

animate_pincer_bug_2872:                                             ; ...
2872: 21 77 28    ld      hl,pincer_bug_sprite_tbl_2877
2875: 18 CB       jr      set_4_sprite_code_colour_2842
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------

animate_star_287b:                                                   ; ...
287B: 21 80 28    ld      hl,star_sprite_code_tbl_2880
287E: 18 C2       jr      set_4_sprite_code_colour_2842
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------

animate_spinning_disc_2884:                                          ; ...
2884: CD 5D 3E    call    upd_spinning_disc_sprite_code_3e5d
2887: FD 36 01 06 ld      (iy+$01),6                       ; sprite colour
288B: C9          ret
; ---------------------------------------------------------------------------
; *** UNUSED???
288C: 0E C4       ld      c,$C4 ; '�'
288E: DD 7E 0B    ld      a,(ix+$0B)
2891: E6 01       and     1
2893: 81          add     a,c
2894: FD 77 00    ld      (iy+$00),a
2897: C9          ret

; =============== S U B R O U T I N E =======================================


lookup_dy_dx_store_2898:                                             ; ...
2898: CD CB 28    call    lookup_dy_dx_28cb                    ; get dy,dx
289B: DD 72 06    ld      (ix+$06),d                        ; update obj dy msb
289E: DD 73 07    ld      (ix+$07),e                        ; update obj dy lsb
28A1: DD 70 08    ld      (ix+$08),b                        ; update obj dx msb
28A4: DD 71 09    ld      (ix+$09),c                        ; update obj dx lsb
28A7: C9          ret
; End of function lookup_dy_dx_store_2898


; =============== S U B R O U T I N E =======================================


move_object_lookup_28a8:                                             ; ...
28A8: CD CB 28    call    lookup_dy_dx_28cb                    ; get dy,dx
28AB: FD 66 02    ld      h,(iy+$02)                        ; sprite y
28AE: DD 6E 03    ld      l,(ix+$03)                        ; obj y lsb
28B1: 19          add     hl,de                          ; calc y+dy
28B2: ED 5B 09 E1 ld      de,(airborne_dy_e109)
28B6: 19          add     hl,de                          ; move w/bg
28B7: FD 74 02    ld      (iy+$02),h                        ; update sprite y
28BA: DD 75 03    ld      (ix+$03),l                        ; update obj y lsb
28BD: FD 66 03    ld      h,(iy+$03)                        ; sprite x
28C0: DD 6E 04    ld      l,(ix+$04)                        ; obj x lsb
28C3: 09          add     hl,bc                          ; calc x+dx
28C4: FD 74 03    ld      (iy+$03),h                        ; update sprite x
28C7: DD 75 04    ld      (ix+$04),l                        ; update obj x lsb
28CA: C9          ret
; End of function move_object_lookup_28a8


; =============== S U B R O U T I N E =======================================


lookup_dy_dx_28cb:                                                   ; ...
28CB: DD 7E 0A    ld      a,(ix+$0a)                      ; lookup table entry
28CE: 21 20 9C    ld      hl,off_9c20
28D1: EF          rst     de_eq_contents_hl_plus_2a_0028
28D2: EB          ex      de,hl
28D3: DD 7E 01    ld      a,(ix+$01)                        ; obj counter
28D6: 47          ld      b,a
28D7: 0F          rrca
28D8: E6 1F       and     $1F
28DA: 28 38       jr      Z,loc_2914
28DC: CB 70       bit     6,b
28DE: 20 08       jr      NZ,loc_28e8
28E0: 47          ld      b,a
28E1: 2F          cpl
28E2: E6 1F       and     $1F
28E4: 4F          ld      c,a
28E5: C3 ED 28    jp      loc_28ed
; ---------------------------------------------------------------------------

loc_28e8:                                                       ; ...
28E8: 4F          ld      c,a
28E9: 2F          cpl
28EA: E6 1F       and     $1F
28EC: 47          ld      b,a

loc_28ed:                                                       ; ...
28ED: E5          push    hl
28EE: 79          ld      a,c
28EF: EF          rst     de_eq_contents_hl_plus_2a_0028
28F0: 78          ld      a,b
28F1: 42          ld      b,d
28F2: 4B          ld      c,e
28F3: E1          pop     hl
28F4: EF          rst     de_eq_contents_hl_plus_2a_0028
28F5: DD CB 01 7E bit     7,(ix+$01)
28F9: 28 08       jr      Z,loc_2903
28FB: 21 00 00    ld      hl,0
28FE: A7          and     a
28FF: ED 42       sbc     hl,bc
2901: 44          ld      b,h
2902: 4D          ld      c,l

loc_2903:                                                       ; ...
2903: DD 7E 01    ld      a,(ix+$01)
2906: C6 40       add     a,$40 ; '@'
2908: CB 7F       bit     7,a
290A: C8          ret     Z
290B: 21 00 00    ld      hl,0
290E: A7          and     a
290F: ED 52       sbc     hl,de
2911: 54          ld      d,h
2912: 5D          ld      e,l
2913: C9          ret
; ---------------------------------------------------------------------------

loc_2914:                                                       ; ...
2914: 78          ld      a,b
2915: 4E          ld      c,(hl)
2916: 23          inc     hl
2917: 46          ld      b,(hl)
2918: 07          rlca
2919: 07          rlca
291A: E6 03       and     3
291C: F7          rst    $30	  ; [jump_to_jump_table] [nb_entries=4]
; ---------------------------------------------------------------------------
	.word loc_2925
	.word loc_292b
	.word loc_292f
	.word loc_293b
; ---------------------------------------------------------------------------

loc_2925:                                                       ; ...
2925: 50          ld      d,b
2926: 59          ld      e,c
2927: 01 00 00    ld      bc,0
292A: C9          ret
; End of function lookup_dy_dx_28cb

; ---------------------------------------------------------------------------

loc_292b:                                                       ; ...
292B: 11 00 00    ld      de,0
292E: C9          ret
; ---------------------------------------------------------------------------

loc_292f:                                                       ; ...
292F: 21 00 00    ld      hl,0
2932: A7          and     a
2933: ED 42       sbc     hl,bc
2935: 54          ld      d,h
2936: 5D          ld      e,l
2937: 01 00 00    ld      bc,0
293A: C9          ret
; ---------------------------------------------------------------------------

loc_293b:                                                       ; ...
293B: 21 00 00    ld      hl,0
293E: A7          and     a
293F: ED 42       sbc     hl,bc
2941: 44          ld      b,h
2942: 4D          ld      c,l
2943: 11 00 00    ld      de,0
2946: C9          ret

; =============== S U B R O U T I N E =======================================


scroll_ground_object_with_gnd_2947:                                  ; ...
2947: FD 56 03    ld      d,(iy+$03)                        ; sprite x
294A: 21 80 FF    ld      hl,-128
294D: DD 5E 04    ld      e,(ix+$04)                        ; obj x LSB
2950: 19          add     hl,de
2951: FD 74 03    ld      (iy+$03),h                        ; update sprite x
2954: DD 75 04    ld      (ix+$04),l                        ; update object x LSB
2957: 2A 0B E1    ld      hl,(ground_dy_e10b)
295A: 11 00 00    ld      de,0
295D: EB          ex      de,hl
295E: A7          and     a
295F: ED 52       sbc     hl,de                          ; negate
2961: FD 56 02    ld      d,(iy+$02)                        ; sprite y
2964: DD 5E 03    ld      e,(ix+$03)                        ; obj y lsb
2967: 19          add     hl,de                          ; move w/bg
2968: FD 74 02    ld      (iy+$02),h                        ; update sprite y
296B: DD 75 03    ld      (ix+$03),l                        ; update obj y lsb
296E: C9          ret
; End of function scroll_ground_object_with_gnd_2947


; =============== S U B R O U T I N E =======================================


scroll_airborne_object_with_gnd_296f:                                ; ...
296F: FD 56 03    ld      d,(iy+$03)                        ; sprite x
2972: 21 80 FF    ld      hl,-128
2975: DD 5E 04    ld      e,(ix+$04)                        ; obj x lsb
2978: 19          add     hl,de                          ; calc x-128
2979: FD 74 03    ld      (iy+$03),h                        ; update sprite x
297C: DD 75 04    ld      (ix+$04),l                        ; update obj x lsb
297F: 2A 09 E1    ld      hl,(airborne_dy_e109)
2982: FD 56 02    ld      d,(iy+$02)                        ; sprite y
2985: DD 5E 03    ld      e,(ix+$03)                        ; obj y lsb
2988: 19          add     hl,de                          ; move w/bg
2989: FD 74 02    ld      (iy+$02),h                        ; update sprite y
298C: DD 75 03    ld      (ix+$03),l                        ; update obj y lsb
298F: C9          ret
; End of function scroll_airborne_object_with_gnd_296f

; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR update_sprite_bullets_1ca5

deactivate_obj_2990:                                                 ; ...
2990: DD 36 00 00 ld      (ix+$00),0                       ; set inactive
2994: FD 36 02 00 ld      (iy+$02),0                       ; sprite y=0
2998: C9          ret
; END OF FUNCTION CHUNK FOR update_sprite_bullets_1ca5

; =============== S U B R O U T I N E =======================================


update_alien_bullets_2999:                                           ; ...
2999: DD 21 A0 E2 ld      ix,alien_bullet_obj_tbl_e2a0
299D: FD 21 44 EF ld      iy,spriteram_shadow_ef00+0x44     ; set s17.code as base
29A1: 06 06       ld      b,6                           ; 6 alien bullets
29A3: AF          xor     a
29A4: 32 AD E0    ld      (num_active_alien_bullets_e0ad),a   ; zero cnt

loc_29a7:                                                       ; ...
29A7: C5          push    bc
29A8: DD 7E 00    ld      a,(ix+$00)                        ; state
29AB: A7          and     a                               ; inactive?
29AC: 28 0B       jr      Z,loc_29b9                     ; yes,skip
29AE: 21 B9 29    ld      hl,loc_29b9			; [push_function]
29B1: E5          push    hl                              ; save return address
29B2: 3C          inc     a                               ; active?
29B3: CA C7 29    jp      Z,update_alien_bullet_29c7          ; yes,go
29B6: C3 90 29    jp      deactivate_obj_2990
; ---------------------------------------------------------------------------

loc_29b9:                                                       ; ...
29B9: 11 10 00    ld      de,$10
29BC: DD 19       add     ix,de                          ; next object
29BE: 11 04 00    ld      de,4
29C1: FD 19       add     iy,de                          ; next sprite
29C3: C1          pop     bc
29C4: 10 E1       djnz    loc_29a7                        ; loop
29C6: C9          ret
; ---------------------------------------------------------------------------

update_alien_bullet_29c7:                                            ; ...
29C7: CD 2B 24    call    check_sprite_off_screen_242b         ; off-screen?
29CA: DA 90 29    jp      C,deactivate_obj_2990               ; yes,go
29CD: 21 AD E0    ld      hl,num_active_alien_bullets_e0ad
29D0: 34          inc     (hl)                            ; cnt++
29D1: CD 3B 24    call    move_object_self_243b
29D4: 3A 00 E0    ld      a,(vblank_tick_e000)
29D7: E6 03       and     3
29D9: C6 03       add     a,3                           ; calc colour
29DB: FD 77 01    ld      (iy+$01),a                        ; sprite colour
29DE: C9          ret
; End of function update_alien_bullets_2999


; =============== S U B R O U T I N E =======================================


handle_e200_firing_29df:                                             ; ...
29DF: 3A A8 E0    ld      a,(alien_bullet_tmr_e0a8)
29E2: A7          and     a                               ; expired?
29E3: C0          ret     NZ                              ; no,exit
29E4: 3A A4 E0    ld      a,(area_max_alien_bullets_e0a4)
29E7: A7          and     a                               ; zero?
29E8: C8          ret     Z                               ; yes,exit
29E9: 47          ld      b,a                            ; save
29EA: 3A AD E0    ld      a,(num_active_alien_bullets_e0ad)
29ED: B8          cp      b                               ; less than max?
29EE: D0          ret     NC                              ; no,exit
29EF: 3A 00 E1    ld      a,(ship_obj_e100)
29F2: 3C          inc     a                               ; active?
29F3: C0          ret     NZ                              ; no,exit
29F4: DD E5       push    ix
29F6: E1          pop     hl                              ; (firing) obj ptr
29F7: 3A 00 E0    ld      a,(vblank_tick_e000)
29FA: E6 1F       and     $1F
29FC: 47          ld      b,a                            ; save
29FD: 7D          ld      a,l                            ; (firing) obj ptr lsb
29FE: E6 1F       and     $1F
2A00: B8          cp      b                               ; bottom 5 bits same as blank_tick?
2A01: C0          ret     NZ                              ; no,exit
; determine whether aliens are too close to fire
; - some weird maths right here...
; - how does this work when (s0.y-obj y) is -ve?
; - and weirder because every entry in the table is 0xA
2A02: 3A B6 E0    ld      a,(area_alien_fire_proximity_limit_e0b6)
2A05: 47          ld      b,a                            ; save
2A06: 87          add     a,a                            ; x2
2A07: 3C          inc     a                               ; x2+1
2A08: 4F          ld      c,a                            ; save
2A09: 3A 02 EF    ld      a,(spriteram_shadow_ef00+2)         ; s0.y
2A0C: FD 96 02    sub     (iy+$02)                           ; s0.y - (firing) obj sprite y
2A0F: 80          add     a,b                            ; s0.y - obj y + limit
2A10: B9          cp      c                               ; (s0.y - obj y + limit) < (limit x2)+1)?
2A11: D8          ret     C                               ; yes,return
2A12: CD 95 6A    call    aim_directly_at_ship_6a95
2A15: 4F          ld      c,a
2A16: DD 96 01    sub     (ix+$01)
2A19: C6 20       add     a,$20 ; ' '
2A1B: FE 29       cp      $29 ; ')'
2A1D: D0          ret     NC
; try to spawn an alien bullet
; if there is a free slot
2A1E: DD E5       push    ix
2A20: FD E5       push    iy
2A22: FD 66 02    ld      h,(iy+$02)                        ; obj??? sprite y
2A25: FD 6E 03    ld      l,(iy+$03)                        ; obj??? sprite x
2A28: DD 21 A0 E2 ld      ix,alien_bullet_obj_tbl_e2a0
2A2C: FD 21 44 EF ld      iy,spriteram_shadow_ef00+0x44     ; s17.code as base
2A30: 06 06       ld      b,6                           ; 6 alien bullet slots
2A32: D9          exx
2A33: 11 04 00    ld      de,4                          ; bytes per sprite
2A36: 01 10 00    ld      bc,$10                       ; bytes per object
2A39: D9          exx

loc_2a3a:                                                       ; ...
2A3A: DD 7E 00    ld      a,(ix+$00)                        ; obj state
2A3D: A7          and     a                               ; inactive?
2A3E: CA 4E 2A    jp      Z,spawn_alien_bullet_2a4e           ; yes,go
2A41: D9          exx
2A42: DD 09       add     ix,bc                          ; next object
2A44: FD 19       add     iy,de                          ; next sprite
2A46: D9          exx
2A47: 10 F1       djnz    loc_2a3a                        ; loop
2A49: FD E1       pop     iy
2A4B: DD E1       pop     ix
2A4D: C9          ret
; ---------------------------------------------------------------------------

spawn_alien_bullet_2a4e:                                             ; ...
2A4E: FD 74 02    ld      (iy+$02),h                        ; init sprite y
2A51: FD 75 03    ld      (iy+$03),l                        ; init sprite x
2A54: FD 36 00 5F ld      (iy+$00),$5F ; '_'              ; sprite code (alien bullet)
2A58: DD 36 00 FF ld      (ix+$00),$FF                    ; obj state=active
2A5C: DD 71 01    ld      (ix+$01),c                        ; obj counter (returned from aim routine)
2A5F: DD 36 05 00 ld      (ix+$05),0                       ; obj type
2A63: 3A B7 E0    ld      a,(area_dy_dx_lookup_tbl_entry_e0b7)
2A66: DD 77 0A    ld      (ix+$0a),a                      ; dy_dx_lookup table entry
2A69: DD 36 0F 00 ld      (ix+$0f),0                     ; aim directly at ship
2A6D: CD 98 28    call    lookup_dy_dx_store_2898
2A70: 3A A7 E0    ld      a,(area_alien_bullet_tmr_init_e0a7)
2A73: 32 A8 E0    ld      (alien_bullet_tmr_e0a8),a           ; re-init bullet timer_e025
2A76: FD E1       pop     iy
2A78: DD E1       pop     ix
2A7A: C9          ret
; End of function handle_e200_firing_29df


; =============== S U B R O U T I N E =======================================


init_rand_2a7b:                                                      ; ...
2A7B: 21 87 2A    ld      hl,init_rand_seed_2a87
2A7E: 11 4A EE    ld      de,rand_buffer_ee4a
2A81: 01 0A 00    ld      bc,10
2A84: ED B0       ldir
2A86: C9          ret
; End of function init_rand_2a7b

; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================


rand_2a91:                                                           ; ...
2A91: 3A 4A EE    ld      a,(rand_buffer_ee4a)
2A94: 47          ld      b,a
2A95: 3A 00 E0    ld      a,(vblank_tick_e000)
2A98: 80          add     a,b
2A99: 47          ld      b,a
2A9A: 3A 00 EF    ld      a,(spriteram_shadow_ef00)           ; s0.code
2A9D: 80          add     a,b
2A9E: 21 4B EE    ld      hl,rand_buffer_ee4a+1
2AA1: 11 4A EE    ld      de,rand_buffer_ee4a
2AA4: ED A0       ldi
2AA6: ED A0       ldi
2AA8: ED A0       ldi
2AAA: ED A0       ldi
2AAC: ED A0       ldi
2AAE: ED A0       ldi
2AB0: ED A0       ldi
2AB2: ED A0       ldi
2AB4: ED A0       ldi
2AB6: 32 53 EE    ld      (last_rand_ee53),a
2AB9: C9          ret
; End of function rand_2a91


; =============== S U B R O U T I N E =======================================


handle_large_alien_bullets_2aba:                                     ; ...
2ABA: 3A 00 E0    ld      a,(vblank_tick_e000)
2ABD: E6 1F       and     $1F                           ; time to fire?
2ABF: C0          ret     NZ                              ; no,exit
2AC0: FD 7E 03    ld      a,(iy+$03)                        ; sn.x
2AC3: FE 58       cp      88                             ; too low?
2AC5: D8          ret     C                               ; yes,exit
2AC6: 3A 00 E1    ld      a,(ship_obj_e100)
2AC9: 3C          inc     a                               ; active?
2ACA: C0          ret     NZ                              ; no,exit
2ACB: 3A 1E E0    ld      a,(max_bullets_with_large_alien_e01e)
2ACE: A7          and     a
2ACF: C8          ret     Z
2AD0: FE 06       cp      6                              ; max possible?
2AD2: D0          ret     NC                              ; yes,exit
2AD3: 47          ld      b,a                            ; max  slots to check
2AD4: D9          exx
2AD5: DD E5       push    ix
2AD7: FD E5       push    iy
; look for a free slot and spawn alien bullet
2AD9: FD 7E 02    ld      a,(iy+$02)                        ; sn.y
2ADC: C6 08       add     a,8                           ; +8
2ADE: 67          ld      h,a
2ADF: FD 7E 03    ld      a,(iy+$03)                        ; sn.x
2AE2: C6 08       add     a,8                           ; +8
2AE4: 6F          ld      l,a
2AE5: DD 21 F0 E2 ld      ix,alien_bullet_obj_tbl_e2a0+0x50 ; 6th entry
2AE9: FD 21 58 EF ld      iy,spriteram_shadow_ef00+0x58     ; s22.code
2AED: 11 FC FF    ld      de,-4                         ; 4 bytes per sprite
2AF0: 01 F0 FF    ld      bc,-16                        ; 16 bytes per object
2AF3: D9          exx

loc_2af4:                                                       ; ...
2AF4: DD 7E 00    ld      a,(ix+$00)                        ; obj state
2AF7: A7          and     a                               ; active?
2AF8: 28 0D       jr      Z,spawn_large_alien_bullet_2b07     ; no,go
2AFA: D9          exx
2AFB: FD 19       add     iy,de                          ; prev sprite
2AFD: DD 09       add     ix,bc                          ; prev object
2AFF: D9          exx
2B00: 10 F2       djnz    loc_2af4
2B02: FD E1       pop     iy
2B04: DD E1       pop     ix
2B06: C9          ret
; ---------------------------------------------------------------------------

spawn_large_alien_bullet_2b07:                                       ; ...
2B07: D9          exx
2B08: FD 74 02    ld      (iy+$02),h                        ; copy to s.x
2B0B: FD 75 03    ld      (iy+$03),l                        ; copy to s.y
2B0E: FD 36 00 5F ld      (iy+$00),$5F ; '_'              ; alien bullet
2B12: CD 95 6A    call    aim_directly_at_ship_6a95
2B15: DD 77 01    ld      (ix+$01),a
2B18: DD 36 0A 0D ld      (ix+$0a),$D
2B1C: CD 98 28    call    lookup_dy_dx_store_2898
2B1F: DD 36 05 00 ld      (ix+$05),0                       ; obj type=0
2B23: DD 36 00 FF ld      (ix+$00),$FF                    ; obj state=active
2B27: FD E1       pop     iy
2B29: DD E1       pop     ix
2B2B: C9          ret
; End of function handle_large_alien_bullets_2aba


; =============== S U B R O U T I N E =======================================


reset_some_stuff_2b2c:                                               ; ...
2B2C: 3E 01       ld      a,1
2B2E: 32 AA E0    ld      (wait_formation_free_slots_e0aa),a
2B31: 32 B2 E0    ld      (wait_formation_spawn_tmr_e0b2),a   ; flag no spawn
2B34: AF          xor     a
2B35: 32 AB E0    ld      (spawn_flying_free_slot_threshold_e0ab),a
2B38: 32 C5 E0    ld      (area_tmr_e0c5),a
2B3B: 32 B1 E0    ld      (byte_e0b1),a
2B3E: 32 99 E1    ld      (pickup_obj_e190+9),a
2B41: 3D          dec     a
2B42: 32 98 E1    ld      (pickup_obj_e190+8),a
2B45: C9          ret
; End of function reset_some_stuff_2b2c


; =============== S U B R O U T I N E =======================================


init_planet_area_data_2b46:                                          ; ...
2B46: 21 AC 5D    ld      hl,planet_area_data_tbl_5dac
2B49: 3A 02 E5    ld      a,(map_planet_e502)
2B4C: EF          rst     de_eq_contents_hl_plus_2a_0028
2B4D: 3A 03 E5    ld      a,(map_area_e503)
2B50: 6F          ld      l,a
2B51: 26 00       ld      h,0
2B53: 29          add     hl,hl                          ; x2
2B54: 29          add     hl,hl                          ; x4
2B55: 29          add     hl,hl                          ; x8
2B56: 29          add     hl,hl                          ; x16
2B57: 19          add     hl,de                          ; entry + (map_area_e503) x16
2B58: 7E          ld      a,(hl)                         ; @$0
2B59: 23          inc     hl
2B5A: 32 A4 E0    ld      (area_max_alien_bullets_e0a4),a
2B5D: 7E          ld      a,(hl)                         ; @$1
2B5E: 23          inc     hl
2B5F: 32 B6 E0    ld      (area_alien_fire_proximity_limit_e0b6),a
2B62: 7E          ld      a,(hl)                         ; @$2
2B63: 23          inc     hl
2B64: 32 A7 E0    ld      (area_alien_bullet_tmr_init_e0a7),a
2B67: 32 A8 E0    ld      (alien_bullet_tmr_e0a8),a
2B6A: 7E          ld      a,(hl)                         ; @$3
2B6B: 23          inc     hl
2B6C: 32 B7 E0    ld      (area_dy_dx_lookup_tbl_entry_e0b7),a
2B6F: 7E          ld      a,(hl)                         ; @$4
2B70: 23          inc     hl
2B71: 32 B8 E0    ld      (area_spawn_flying_threshold_adjust_e0b8),a
2B74: 7E          ld      a,(hl)                         ; @$5
2B75: 23          inc     hl
2B76: 32 B9 E0    ld      (area_firing_alien_type_e0b9),a
2B79: 7E          ld      a,(hl)                         ; @$6
2B7A: 23          inc     hl
2B7B: 32 BA E0    ld      (tmr_e0bb_init_e0ba),a
2B7E: 3E 10       ld      a,$10
2B80: 32 BB E0    ld      (byte_e0bb),a
2B83: 7E          ld      a,(hl)                         ; @$7
2B84: 23          inc     hl
2B85: 32 A5 E0    ld      (area_firing_alien_spawn_tmr_init_e0a5),a
2B88: 32 A6 E0    ld      (firing_alien_spawn_tmr_e0a6),a
2B8B: 7E          ld      a,(hl)                         ; @$8
2B8C: 23          inc     hl
2B8D: 32 BC E0    ld      (byte_e0bc),a
2B90: 32 BD E0    ld      (byte_e0bd),a
2B93: 7E          ld      a,(hl)                         ; @$9
2B94: 23          inc     hl
2B95: 32 BE E0    ld      (area_formation_type_e0be),a
2B98: 7E          ld      a,(hl)                         ; @$A
2B99: 23          inc     hl
2B9A: 32 BF E0    ld      (area_formation_spawn_tmr_e0bf),a
2B9D: 7E          ld      a,(hl)                         ; @$B
2B9E: 23          inc     hl
2B9F: 47          ld      b,a
2BA0: E6 0F       and     $F
2BA2: 32 C2 E0    ld      (area_large_alien_type_e0c2),a
2BA5: 78          ld      a,b
2BA6: 0F          rrca
2BA7: 0F          rrca
2BA8: 0F          rrca
2BA9: 0F          rrca
2BAA: E6 0F       and     $F                            ; hi->lo nibble
2BAC: 32 C1 E0    ld      (area_large_alien_obj_cnt_e0c1),a
2BAF: 7E          ld      a,(hl)                         ; @$C
2BB0: 23          inc     hl
2BB1: 32 C3 E0    ld      (byte_e0c3),a
2BB4: 7E          ld      a,(hl)                         ; @$D
2BB5: 23          inc     hl
2BB6: 32 C0 E0    ld      (area_large_alien_spawn_tmr_init_e0c0),a
2BB9: 32 C4 E0    ld      (large_alien_spawn_tmr_e0c4),a
2BBC: AF          xor     a
2BBD: 32 C6 E0    ld      (byte_e0c6),a
2BC0: 7E          ld      a,(hl)                         ; @$E
2BC1: 23          inc     hl
2BC2: 32 B5 E0    ld      (area_non_firing_alien_type_1_based_e0b5),a
2BC5: 3D          dec     a
2BC6: 32 C9 E0    ld      (area_non_firing_alien_type_0_based_e0c9),a
2BC9: 7E          ld      a,(hl)                         ; @$F
2BCA: 23          inc     hl
2BCB: 32 CB E0    ld      (area_formation_alien_type_e0cb),a
2BCE: 32 AA E0    ld      (wait_formation_free_slots_e0aa),a  ; any non-zero value
2BD1: 3E 01       ld      a,1
2BD3: 32 B2 E0    ld      (wait_formation_spawn_tmr_e0b2),a   ; flag no spawn
2BD6: 21 E1 2B    ld      hl,max_large_alien_bullet_tbl_2be1
2BD9: 3A 02 E5    ld      a,(map_planet_e502)                 ; calc offset
2BDC: E7          rst     content_hl_plus_a_0020
2BDD: 32 1E E0    ld      (max_bullets_with_large_alien_e01e),a
2BE0: C9          ret
; End of function init_planet_area_data_2b46

; ---------------------------------------------------------------------------
; maximum number of slots to check for large alien bullets


; =============== S U B R O U T I N E =======================================


tick_timers_2beb:                                                    ; ...
2BEB: 21 A8 E0    ld      hl,alien_bullet_tmr_e0a8
2BEE: 7E          ld      a,(hl)
2BEF: A7          and     a                               ; expired?
2BF0: 28 01       jr      Z,loc_2bf3                     ; yes,skip
2BF2: 35          dec     (hl)                            ; tick

loc_2bf3:                                                       ; ...
2BF3: 21 CC E0    ld      hl,byte_e0cc
2BF6: 7E          ld      a,(hl)
2BF7: A7          and     a
2BF8: 28 01       jr      Z,loc_2bfb
2BFA: 35          dec     (hl)

loc_2bfb:                                                       ; ...
2BFB: 21 A6 E0    ld      hl,firing_alien_spawn_tmr_e0a6
2BFE: 7E          ld      a,(hl)
2BFF: A7          and     a                               ; expired?
2C00: 28 01       jr      Z,loc_2c03                     ; yes,skip
2C02: 35          dec     (hl)                            ; tick

loc_2c03:                                                       ; ...
2C03: 21 BB E0    ld      hl,byte_e0bb
2C06: 7E          ld      a,(hl)
2C07: A7          and     a
2C08: 28 09       jr      Z,loc_2c13
2C0A: 35          dec     (hl)
2C0B: 20 06       jr      NZ,loc_2c13
2C0D: 3A BC E0    ld      a,(byte_e0bc)
2C10: 32 BD E0    ld      (byte_e0bd),a

loc_2c13:                                                       ; ...
2C13: 3A 00 E0    ld      a,(vblank_tick_e000)
2C16: E6 01       and     1
2C18: C0          ret     NZ
2C19: 21 C4 E0    ld      hl,large_alien_spawn_tmr_e0c4
2C1C: 7E          ld      a,(hl)
2C1D: A7          and     a                               ; expired?
2C1E: 28 01       jr      Z,loc_2c21                     ; yes,skip
2C20: 35          dec     (hl)                            ; tick

loc_2c21:                                                       ; ...
2C21: 21 BF E0    ld      hl,area_formation_spawn_tmr_e0bf
2C24: 7E          ld      a,(hl)
2C25: A7          and     a                               ; expired?
2C26: 28 07       jr      Z,loc_2c2f                     ; no,skip
2C28: 35          dec     (hl)                            ; tick
2C29: 20 04       jr      NZ,loc_2c2f                    ; not expired,skip
2C2B: AF          xor     a                               ; flag formation spawn
2C2C: 32 B2 E0    ld      (wait_formation_spawn_tmr_e0b2),a

loc_2c2f:                                                       ; ...
2C2F: 21 C5 E0    ld      hl,area_tmr_e0c5
2C32: 35          dec     (hl)                            ; expired?
2C33: C0          ret     NZ                              ; no,exit
2C34: 21 03 E5    ld      hl,map_area_e503
2C37: 34          inc     (hl)                            ; next area
2C38: C3 46 2B    jp      init_planet_area_data_2b46
; End of function tick_timers_2beb


; =============== S U B R O U T I N E =======================================


spawn_e200_objects_2c3b:                                             ; ...

; FUNCTION CHUNK AT ROM:2E81 SIZE 0000004A BYTES
; FUNCTION CHUNK AT ROM:2F14 SIZE 0000001A BYTES

2C3B: 3A B2 E0    ld      a,(wait_formation_spawn_tmr_e0b2)
2C3E: A7          and     a                               ; time to spawn a formation?
2C3F: CA 81 2E    jp      Z,check_spawn_formation_2e81        ; yes,go
2C42: 3A BB E0    ld      a,(byte_e0bb)
2C45: A7          and     a
2C46: C0          ret     NZ
2C47: 3A A6 E0    ld      a,(firing_alien_spawn_tmr_e0a6)
2C4A: A7          and     a                               ; expired?
2C4B: C0          ret     NZ                              ; no,exit
2C4C: 3A B8 E0    ld      a,(area_spawn_flying_threshold_adjust_e0b8)
2C4F: 47          ld      b,a                            ; save
; easiest to think of the threshold as the number of flying aliens active (initially)
; - then decremented with a timer_e025 to allow formations to form
; - so missing E increases alien spawn frequency
2C50: 3A AB E0    ld      a,(spawn_flying_free_slot_threshold_e0ab)
2C53: B8          cp      b                               ; less than missed E?
2C54: D0          ret     NC                              ; no,exit
2C55: DD 21 00 E2 ld      ix,e200_obj_tbl_e200
2C59: FD 21 20 EF ld      iy,spriteram_shadow_ef00+0x20     ; set s8.code as base
2C5D: 11 10 00    ld      de,$10                       ; bytes per obj
2C60: 01 04 00    ld      bc,4                          ; bytes per sprite

loc_2c63:                                                       ; ...
2C63: DD 7E 00    ld      a,(ix+$00)                        ; obj state
2C66: A7          and     a                               ; inactive?
2C67: 28 06       jr      Z,free_e200_obj_slot_2c6f           ; yes,go
2C69: DD 19       add     ix,de                          ; next object
2C6B: FD 09       add     iy,bc                          ; next sprite
2C6D: 18 F4       jr      loc_2c63                        ; loop
; ---------------------------------------------------------------------------
; this will get here even if no free slots!!!

free_e200_obj_slot_2c6f:                                             ; ...
2C6F: CD AE 2C    call    spawn_e200_object_2cae
2C72: 21 BD E0    ld      hl,byte_e0bd
2C75: 35          dec     (hl)
2C76: 28 07       jr      Z,loc_2c7f
2C78: 3A A5 E0    ld      a,(area_firing_alien_spawn_tmr_init_e0a5)
2C7B: 32 A6 E0    ld      (firing_alien_spawn_tmr_e0a6),a
2C7E: C9          ret
; ---------------------------------------------------------------------------

loc_2c7f:                                                       ; ...
2C7F: 3A BA E0    ld      a,(tmr_e0bb_init_e0ba)
2C82: 32 BB E0    ld      (byte_e0bb),a
2C85: C9          ret
; End of function spawn_e200_objects_2c3b

; ---------------------------------------------------------------------------
; the sprite gets changed to a spinning_disc
; before it is ever displayed
; START OF FUNCTION CHUNK FOR spawn_e200_object_2cae

spawn_japanese_symbol_2c86:                                          ; ...
2C86: DD 36 00 FF ld      (ix+$00),$FF                    ; active
2C8A: DD 36 05 0F ld      (ix+$05),$F                     ; init type=15
2C8E: FD 36 03 E0 ld      (iy+$03),224                     ; init sprite x
2C92: FD 36 02 10 ld      (iy+$02),16                      ; init sprite y
2C96: FD 36 00 C4 ld      (iy+$00),$C4 ; '�'              ; sprite code=japanese symbol
2C9A: FD 36 01 00 ld      (iy+$01),0                       ; sprite colour
2C9E: DD 36 01 E0 ld      (ix+$01),$E0 ; '�'              ; obj counter
2CA2: DD 36 0A 02 ld      (ix+$0a),2                     ; dy_dx_lookup table index
2CA6: CD 98 28    call    lookup_dy_dx_store_2898
2CA9: AF          xor     a
2CAA: 32 9D E0    ld      (spawn_jap_symb_flag_e09d),a        ; clear flag
2CAD: C9          ret
; END OF FUNCTION CHUNK FOR spawn_e200_object_2cae

; =============== S U B R O U T I N E =======================================


spawn_e200_object_2cae:                                              ; ...

; FUNCTION CHUNK AT ROM:2C86 SIZE 00000028 BYTES

2CAE: 3A 9D E0    ld      a,(spawn_jap_symb_flag_e09d)
2CB1: A7          and     a                               ; spawn japanese symbol?
2CB2: 20 D2       jr      NZ,spawn_japanese_symbol_2c86       ; yes,go
2CB4: 3A B9 E0    ld      a,(area_firing_alien_type_e0b9)
2CB7: FE 0A       cp      10                             ; type 10 (rock)?
2CB9: 28 32       jr      Z,spawn_rock_2ced                   ; yes,go
2CBB: CD 91 2A    call    rand_2a91
2CBE: E6 1F       and     31
2CC0: 47          ld      b,a
2CC1: 87          add     a,a                            ; x2
2CC2: 80          add     a,b                            ; x3
2CC3: 21 21 2E    ld      hl,e200_spawn_init_tbl_2e21
2CC6: E7          rst     content_hl_plus_a_0020               ; get 1st byte
2CC7: FD 77 02    ld      (iy+$02),a                        ; set sprite y
2CCA: 23          inc     hl
2CCB: 7E          ld      a,(hl)                         ; get 2nd byte
2CCC: FD 77 03    ld      (iy+$03),a                        ; set sprite x
2CCF: 23          inc     hl
2CD0: 7E          ld      a,(hl)                         ; get 3rd byte
2CD1: DD 77 01    ld      (ix+$01),a                        ; init counter?
2CD4: DD 77 02    ld      (ix+$02),a                        ; init timer_e025?
2CD7: FD 36 00 FF ld      (iy+$00),$FF                    ; init state=active
2CDB: FD 36 01 00 ld      (iy+$01),0                       ; sprite colour
2CDF: 3A B9 E0    ld      a,(area_firing_alien_type_e0b9)
2CE2: F7          rst    $30		  ; [jump_to_jump_table] [nb_entries=5]
; ---------------------------------------------------------------------------
	.word spawn_tumble_ship_2d3b
	.word spawn_plane_2d69
	.word spawn_ray_2d97
	.word spawn_butterfly_2dc5
	.word spawn_moth_2df3
; ---------------------------------------------------------------------------

spawn_rock_2ced:                                                     ; ...
2CED: 3A 60 E1    ld      a,(large_alien_obj_tbl_e160)        ; object 0
2CF0: 3C          inc     a                               ; active?
2CF1: C0          ret     NZ                              ; no,exit
2CF2: 3A 65 E1    ld      a,(large_alien_obj_tbl_e160+5)      ; obj type
2CF5: FE 03       cp      3                              ; 0-2?
2CF7: D8          ret     C                               ; yes,exit
; large alien is vulgus
2CF8: DD 36 00 FF ld      (ix+$00),$FF                    ; state=active
2CFC: DD 36 05 0A ld      (ix+$05),10                      ; init obj type
2D00: DD 36 0E 00 ld      (ix+$0E),0
2D04: DD 36 0D 28 ld      (ix+$0D),$28 ; '('
2D08: DD 36 0A 00 ld      (ix+$0a),0                     ; lookup_dx_dy index
2D0C: DD E5       push    ix
2D0E: E1          pop     hl
2D0F: 7D          ld      a,l
2D10: E6 70       and     $70 ; 'p'
2D12: 87          add     a,a
2D13: 47          ld      b,a
2D14: 3A 00 E0    ld      a,(vblank_tick_e000)
2D17: E6 7F       and     $7F ; ''
2D19: 87          add     a,a
2D1A: 80          add     a,b
2D1B: DD 77 01    ld      (ix+$01),a
2D1E: 3A CD E0    ld      a,(related_to_big_alien_y_e0cd)
2D21: FD 77 02    ld      (iy+$02),a                        ; sprite y
2D24: 3A CE E0    ld      a,(related_to_big_alien_x_e0ce)
2D27: FD 77 03    ld      (iy+$03),a                        ; sprite x
2D2A: FD 36 00 FF ld      (iy+$00),$FF                    ; sprite code=blank
2D2E: FD 36 01 00 ld      (iy+$01),0                       ; sprite colour
2D32: 3E B4       ld      a,180
2D34: 32 CC E0    ld      (byte_e0cc),a
2D37: CD 98 28    call    lookup_dy_dx_store_2898
2D3A: C9          ret
; End of function spawn_e200_object_2cae

; ---------------------------------------------------------------------------

spawn_tumble_ship_2d3b:                                              ; ...
2D3B: DD 35 00    dec     (ix+$00)                           ; obj state=active
2D3E: DD 36 05 00 ld      (ix+$05),0                       ; obj type
2D42: DD 36 06 60 ld      (ix+$06),96                      ; obj dy
2D46: DD 36 08 20 ld      (ix+$08),32                      ; obj dx
2D4A: DD 36 0A 0A ld      (ix+$0a),$A                   ; dy_dx_lookup table entry
2D4E: 3A 00 E0    ld      a,(vblank_tick_e000)
2D51: 07          rlca
2D52: 07          rlca
2D53: E6 07       and     7
2D55: DD 77 0B    ld      (ix+$0B),a                      ; (related to y)
2D58: DD 36 0C 00 ld      (ix+$0C),0                     ; (related to x)
2D5C: DD 36 0D 00 ld      (ix+$0D),0
2D60: DD 36 0E 30 ld      (ix+$0E),$30 ; '0'
2D64: DD 36 0F 00 ld      (ix+$0f),0                     ; aim directly at ship
2D68: C9          ret
; ---------------------------------------------------------------------------

spawn_plane_2d69:                                                    ; ...
2D69: DD 35 00    dec     (ix+$00)                           ; obj state=active
2D6C: DD 36 05 01 ld      (ix+$05),1                       ; obj type
2D70: DD 36 06 60 ld      (ix+$06),96                      ; obj dy
2D74: DD 36 08 28 ld      (ix+$08),40                      ; obj dx
2D78: DD 36 0A 02 ld      (ix+$0a),2                     ; dy_dx_lookup table entry
2D7C: 3A 00 E0    ld      a,(vblank_tick_e000)
2D7F: 07          rlca
2D80: 07          rlca
2D81: E6 07       and     7
2D83: DD 77 0B    ld      (ix+$0B),a                      ; (related to y)
2D86: DD 36 0C 00 ld      (ix+$0C),0                     ; (related to x)
2D8A: DD 36 0D 00 ld      (ix+$0D),0
2D8E: DD 36 0E 20 ld      (ix+$0E),$20 ; ' '
2D92: DD 36 0F 00 ld      (ix+$0f),0                     ; aim directly at ship
2D96: C9          ret
; ---------------------------------------------------------------------------

spawn_ray_2d97:                                                      ; ...
2D97: DD 35 00    dec     (ix+$00)                           ; obj state=active
2D9A: DD 36 05 02 ld      (ix+$05),2                       ; obj type
2D9E: DD 36 06 70 ld      (ix+$06),112                     ; obj dy
2DA2: DD 36 08 24 ld      (ix+$08),36                      ; obj dx
2DA6: DD 36 0A 05 ld      (ix+$0a),5                     ; dy_dx_lookup table entry
2DAA: 3A 00 E0    ld      a,(vblank_tick_e000)
2DAD: 07          rlca
2DAE: 07          rlca
2DAF: E6 07       and     7
2DB1: DD 77 0B    ld      (ix+$0B),a                      ; (related to y)
2DB4: DD 36 0C 00 ld      (ix+$0C),0                     ; (related to x)
2DB8: DD 36 0D 00 ld      (ix+$0D),0
2DBC: DD 36 0E 20 ld      (ix+$0E),$20 ; ' '
2DC0: DD 36 0F 00 ld      (ix+$0f),0                     ; aim directly at ship
2DC4: C9          ret
; ---------------------------------------------------------------------------

spawn_butterfly_2dc5:                                                ; ...
2DC5: DD 35 00    dec     (ix+$00)                           ; obj state=active
2DC8: DD 36 05 03 ld      (ix+$05),3                       ; obj type
2DCC: DD 36 06 70 ld      (ix+$06),112                     ; obj dy
2DD0: DD 36 08 18 ld      (ix+$08),24                      ; obj dx
2DD4: DD 36 0A 05 ld      (ix+$0a),5                     ; dy_dx_lookup table entry
2DD8: 3A 00 E0    ld      a,(vblank_tick_e000)
2DDB: 07          rlca
2DDC: 07          rlca
2DDD: E6 07       and     7
2DDF: DD 77 0B    ld      (ix+$0B),a                      ; (related to y)
2DE2: DD 36 0C 00 ld      (ix+$0C),0                     ; (related to x)
2DE6: DD 36 0D 00 ld      (ix+$0D),0
2DEA: DD 36 0E 18 ld      (ix+$0E),$18
2DEE: DD 36 0F 00 ld      (ix+$0f),0                     ; aim directly at ship
2DF2: C9          ret
; ---------------------------------------------------------------------------

spawn_moth_2df3:                                                     ; ...
2DF3: DD 35 00    dec     (ix+$00)                           ; obj state=active
2DF6: DD 36 05 04 ld      (ix+$05),4                       ; obj type
2DFA: DD 36 06 90 ld      (ix+$06),144                     ; obj dy
2DFE: DD 36 08 18 ld      (ix+$08),24                      ; obj dx
2E02: DD 36 0A 04 ld      (ix+$0a),4                     ; dy_dx_lookup table entry
2E06: 3A 00 E0    ld      a,(vblank_tick_e000)
2E09: 07          rlca
2E0A: 07          rlca
2E0B: E6 07       and     7
2E0D: DD 77 0B    ld      (ix+$0B),a                      ; (related to y)
2E10: DD 36 0D 00 ld      (ix+$0D),0                     ; (related to x)
2E14: DD 36 0C 00 ld      (ix+$0C),0
2E18: DD 36 0E 28 ld      (ix+$0E),$28 ; '('
2E1C: DD 36 0F 00 ld      (ix+$0f),0                     ; aim directly at ship
2E20: C9          ret
; ---------------------------------------------------------------------------
; init values for e200 objects type 0-4
; - sprite y,sprite x,counter & timer_e025?
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR spawn_e200_objects_2c3b

check_spawn_formation_2e81:                                          ; ...
2E81: 3A CB E0    ld      a,(area_formation_alien_type_e0cb)
2E84: A7          and     a                               ; valid?
2E85: 28 3B       jr      Z,done_spawning_formation_2ec2      ; no,go
2E87: 3A AA E0    ld      a,(wait_formation_free_slots_e0aa)
2E8A: A7          and     a                               ; wait?
2E8B: C2 14 2F    jp      NZ,update_threshold_check_formation_free_slots_2f14 ; yes,go
2E8E: 21 BE E0    ld      hl,area_formation_type_e0be
2E91: 7E          ld      a,(hl)                         ; get entry
2E92: E6 0F       and     $F                            ; paranoid
2E94: 21 2E 2F    ld      hl,formation_data_tbl_2f2e
2E97: EF          rst     de_eq_contents_hl_plus_2a_0028       ; get table
2E98: 1A          ld      a,(de)                         ;  objects to initialise
2E99: 08          ex      af,af'                         ; save
2E9A: 13          inc     de
2E9B: EB          ex      de,hl                          ; HL=ptr byte $01
; this is where we spawn a formation
; note can only spawn as many as free slots
2E9C: AF          xor     a
2E9D: 32 C7 E0    ld      (formation_cnt_e0c7),a
2EA0: DD 21 00 E2 ld      ix,e200_obj_tbl_e200
2EA4: FD 21 20 EF ld      iy,spriteram_shadow_ef00+0x20     ; sprite 8
2EA8: 06 09       ld      b,9                           ; 9 objects

loc_2eaa:                                                       ; ...
2EAA: DD 7E 00    ld      a,(ix+$00)                        ; state
2EAD: A7          and     a                               ; inactive?
2EAE: CC CB 2E    call    Z,spawn_formation_alien_2ecb        ; yes,go
2EB1: 08          ex      af,af'
2EB2: A7          and     a                               ; done all objects?
2EB3: 28 0D       jr      Z,done_spawning_formation_2ec2      ; yes,go
2EB5: 08          ex      af,af'
2EB6: 11 10 00    ld      de,$10
2EB9: DD 19       add     ix,de                          ; next object
2EBB: 11 04 00    ld      de,4
2EBE: FD 19       add     iy,de                          ; next sprite
2EC0: 10 E8       djnz    loc_2eaa                        ; loop

done_spawning_formation_2ec2:                                        ; ...
2EC2: 3E 01       ld      a,1
2EC4: 32 AA E0    ld      (wait_formation_free_slots_e0aa),a
2EC7: 32 B2 E0    ld      (wait_formation_spawn_tmr_e0b2),a   ; flag no spawn
2ECA: C9          ret
; END OF FUNCTION CHUNK FOR spawn_e200_objects_2c3b

; =============== S U B R O U T I N E =======================================


spawn_formation_alien_2ecb:                                          ; ...
2ECB: 08          ex      af,af'
2ECC: 3D          dec     a                               ;  objects to initialise
2ECD: 08          ex      af,af'
2ECE: 7E          ld      a,(hl)                         ; byte $00
2ECF: 23          inc     hl
2ED0: DD 77 0B    ld      (ix+$0B),a                      ; (related to y)
2ED3: 3A CB E0    ld      a,(area_formation_alien_type_e0cb)
2ED6: 86          add     a,(hl)                         ; + byte $01
2ED7: 23          inc     hl
2ED8: DD 77 05    ld      (ix+$05),a                        ; obj type
2EDB: 7E          ld      a,(hl)                         ; byte $02
2EDC: 23          inc     hl
2EDD: DD 77 0D    ld      (ix+$0D),a
2EE0: 7E          ld      a,(hl)                         ; byte $03
2EE1: 23          inc     hl
2EE2: FD 77 02    ld      (iy+$02),a                        ; sprite y
2EE5: 7E          ld      a,(hl)                         ; byte $04
2EE6: 23          inc     hl
2EE7: FD 77 03    ld      (iy+$03),a                        ; sprite x
2EEA: FD 36 00 FF ld      (iy+$00),$FF                    ; sprite code
2EEE: FD 36 01 00 ld      (iy+$01),0                       ; sprite colour
2EF2: 3E FE       ld      a,$FE ; '�'
2EF4: DD 77 00    ld      (ix+$00),a                        ; obj state
2EF7: AF          xor     a
2EF8: DD 77 0C    ld      (ix+$0C),a
2EFB: DD 77 02    ld      (ix+$02),a
2EFE: DD 77 03    ld      (ix+$03),a
2F01: DD 77 04    ld      (ix+$04),a
2F04: DD 36 0F 08 ld      (ix+$0f),8                     ; obj aiming entry
2F08: DD 36 0A 05 ld      (ix+$0a),5
2F0C: 3A C7 E0    ld      a,(formation_cnt_e0c7)
2F0F: 3C          inc     a
2F10: 32 C7 E0    ld      (formation_cnt_e0c7),a
2F13: C9          ret
; End of function spawn_formation_alien_2ecb

; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR spawn_e200_objects_2c3b

update_threshold_check_formation_free_slots_2f14:                    ; ...
2F14: 3A AB E0    ld      a,(spawn_flying_free_slot_threshold_e0ab)
2F17: FE 05       cp      5                              ; >=5?
2F19: 30 05       jr      NC,lower_flying_spawn_threshold_2f20 ; yes,go
; we have 5/6 slots free,enough for a formation
2F1B: AF          xor     a                               ; reached threshold for formation
2F1C: 32 AA E0    ld      (wait_formation_free_slots_e0aa),a  ; flag threshold reached
2F1F: C9          ret
; ---------------------------------------------------------------------------

lower_flying_spawn_threshold_2f20:                                   ; ...
2F20: 3A 00 E0    ld      a,(vblank_tick_e000)
2F23: E6 01       and     1
2F25: C0          ret     NZ
2F26: 21 AB E0    ld      hl,spawn_flying_free_slot_threshold_e0ab
2F29: 35          dec     (hl)                            ; lower threshold
2F2A: C0          ret     NZ
2F2B: C3 C2 2E    jp      done_spawning_formation_2ec2
; END OF FUNCTION CHUNK FOR spawn_e200_objects_2c3b
; ---------------------------------------------------------------------------
;	.word unk_2f4e                            ; ...
;	.word unk_2f6d
;	.word pow_instruct_formation_1_tbl_2f8c
;	.word unk_2fab
;	.word unk_2fca
;	.word bomb_instruct_formation_tbl_2fe9
;	.word unk_3008
;	.word unk_3027
;	.word unk_3065
;	.word unk_3046
;	.word unk_3099
;	.word unk_307f
;	.word unk_30d2
;	.word unk_30b8
;	.word unk_30ec
;	.word unk_310b

; formation object initialisation tables
; 1st byte = objects in table
; for each object:
; *** WRONG!!!!
; $00 - ->$0B ?
; $01 - added to area_formation_alien_type_e0cb
; $02 - -> $0D ?
; $03 - sprite y
; $04 - sprite x

                                                     ; objects to follow
;	.word byte_312a                           ; ...
;	.word byte_313a
;	.word byte_314a
;	.word byte_3154
;	.word byte_315e
;	.word byte_316a
;	.word byte_3176
;	.word byte_3182
;	.word byte_3192
;	.word byte_31a2
;	.word byte_31b4
;	.word byte_31c0
;	.word byte_31d2
;	.word byte_31e4
;	.word byte_31f0
;	.word byte_3202
;	.word byte_320c
;	.word byte_3218
;	.word byte_3224
;	.word byte_322e
;	.word byte_3238
;	.word byte_3240
;	.word byte_324a
;	.word byte_3254
;	.word byte_325e
;	.word byte_3268
;	.word byte_3272
;	.word byte_327c
;	.word byte_328c
;	.word byte_329c
;	.word byte_32ac
;	.word byte_32bc
;	.word byte_32c8
;	.word byte_32f0
;	.word byte_3316
;	.word byte_3326
;	.word byte_3336
;	.word byte_334c
;	.word byte_3360
;	.word byte_33b8
;	.word byte_33c4
;	.word byte_33d0
;	.word byte_33dc
;	.word byte_33e8
;	.word byte_33f4
;	.word byte_3404
;	.word byte_3414
;	.word byte_3422
;	.word byte_3370
;	.word byte_3382
;	.word byte_3394
;	.word byte_33a6

; =============== S U B R O U T I N E =======================================


update_pickup_3494:                                                  ; ...
3494: DD 21 90 E1 ld      ix,pickup_obj_e190
3498: FD 21 5C EF ld      iy,spriteram_shadow_ef00+0x5C     ; set s23.code as base
349C: DD 7E 00    ld      a,(ix+$00)
349F: A7          and     a                               ; inactive?
34A0: 28 22       jr      Z,spawn_pickup_34c4                 ; yes,go
34A2: 3C          inc     a                               ; active?
34A3: CA 2D 36    jp      Z,update_active_pickup_362d         ; yes,go
34A6: DD 35 00    dec     (ix+$00)                           ; state=1?
34A9: 28 0C       jr      Z,deactivate_pickup_34b7            ; yes,go
34AB: 3A 00 E0    ld      a,(vblank_tick_e000)
34AE: 0F          rrca
34AF: E6 03       and     3
34B1: C6 44       add     a,$44 ; 'D'
34B3: FD 77 01    ld      (iy+$01),a                        ; s23.colour
34B6: C9          ret
; ---------------------------------------------------------------------------

deactivate_pickup_34b7:                                              ; ...
34B7: DD 36 00 00 ld      (ix+$00),0                       ; obj state=inactive
34BB: FD 36 01 00 ld      (iy+$01),0                       ; sprite colour
34BF: FD 36 02 00 ld      (iy+$02),0                       ; sprite y
34C3: C9          ret
; ---------------------------------------------------------------------------

spawn_pickup_34c4:                                                   ; ...
34C4: DD 7E 08    ld      a,(ix+$08)                        ; spawn timer_e025
34C7: A7          and     a                               ; expired?
34C8: 28 04       jr      Z,loc_34ce                     ; yes,go
34CA: DD 35 08    dec     (ix+$08)                           ; tick,expired now?
34CD: C0          ret     NZ                              ; no,exit

loc_34ce:                                                       ; ...
34CE: 3A B3 E1    ld      a,(map_planet_space_e1b3)
34D1: E6 01       and     1                              ; in outer space?
34D3: C0          ret     NZ                              ; yes,exit
34D4: 3A 02 E5    ld      a,(map_planet_e502)
34D7: 21 8B 35    ld      hl,pickup_tbl_358b
34DA: EF          rst     de_eq_contents_hl_plus_2a_0028       ; pickup tbl for curr map
34DB: EB          ex      de,hl
34DC: DD 7E 09    ld      a,(ix+$09)                        ; ???
34DF: E6 0F       and     $F
34E1: E7          rst     content_hl_plus_a_0020
34E2: DD 77 05    ld      (ix+$05),a                        ; pickup type
34E5: F7          rst    $30		  ; [jump_to_jump_table] [nb_entries=5]
; End of function update_pickup_3494

; ---------------------------------------------------------------------------
	.word spawn_pow_355c
	.word spawn_e_3541
	.word spawn_s_3526
	.word spawn_d_350b
	.word spawn_star_34f0
; ---------------------------------------------------------------------------

spawn_star_34f0:                                                     ; ...
34F0: CD 91 2A    call    rand_2a91
34F3: E6 7F       and     $7F ; ''
34F5: C6 40       add     a,64                          ; calc sprite y
34F7: FD 77 02    ld      (iy+$02),a                        ; sprite y
34FA: DD 36 00 FF ld      (ix+$00),$FF                    ; obj state=active
34FE: FD 36 03 F0 ld      (iy+$03),$F0 ; '�'              ; sprite x
3502: FD 36 01 00 ld      (iy+$01),0                       ; sprite colour
3506: FD 36 00 2C ld      (iy+$00),$2C ; ','              ; sprite code=star
350A: C9          ret
; ---------------------------------------------------------------------------

spawn_d_350b:                                                        ; ...
350B: CD 91 2A    call    rand_2a91
350E: E6 7F       and     $7F ; ''
3510: C6 40       add     a,64                          ; calc sprite y
3512: FD 77 02    ld      (iy+$02),a                        ; sprite y
3515: DD 36 00 FF ld      (ix+$00),$FF                    ; obj state=active
3519: FD 36 03 F0 ld      (iy+$03),$F0 ; '�'              ; sprite x
351D: FD 36 01 00 ld      (iy+$01),0                       ; sprite colour
3521: FD 36 00 2B ld      (iy+$00),$2B ; '+'              ; sprite code='D'
3525: C9          ret
; ---------------------------------------------------------------------------

spawn_s_3526:                                                        ; ...
3526: CD 91 2A    call    rand_2a91
3529: E6 7F       and     $7F ; ''
352B: C6 40       add     a,64                          ; calc sprite y
352D: FD 77 02    ld      (iy+$02),a                        ; sprite y
3530: DD 36 00 FF ld      (ix+$00),$FF                    ; obj state=active
3534: FD 36 03 F0 ld      (iy+$03),$F0 ; '�'              ; sprite x
3538: FD 36 01 00 ld      (iy+$01),0                       ; sprite colour
353C: FD 36 00 2A ld      (iy+$00),$2A ; '*'              ; sprite code='S'
3540: C9          ret
; ---------------------------------------------------------------------------

spawn_e_3541:                                                        ; ...
3541: CD 91 2A    call    rand_2a91
3544: E6 7F       and     $7F ; ''
3546: C6 40       add     a,64                          ; calc sprite y
3548: FD 77 02    ld      (iy+$02),a                        ; sprite y
354B: DD 36 00 FF ld      (ix+$00),$FF                    ; obj state=active
354F: FD 36 03 F0 ld      (iy+$03),$F0 ; '�'              ; sprite x
3553: FD 36 01 00 ld      (iy+$01),0                       ; sprite colour
3557: FD 36 00 29 ld      (iy+$00),$29 ; ')'              ; sprite code='E'
355B: C9          ret
; ---------------------------------------------------------------------------

spawn_pow_355c:                                                      ; ...
355C: 3A 06 E5    ld      a,(curr_num_bombs_e506)
355F: FE 0F       cp      15                             ; max?
3561: 30 1B       jr      NC,defer_spawn_timer_357e           ; yes,go
3563: CD 91 2A    call    rand_2a91
3566: E6 7F       and     $7F ; ''
3568: C6 40       add     a,64                          ; calc sprite y
356A: FD 77 02    ld      (iy+$02),a                        ; sprite y
356D: DD 36 00 FF ld      (ix+$00),$FF                    ; obj state=active
3571: FD 36 03 F0 ld      (iy+$03),$F0 ; '�'              ; sprite x
3575: FD 36 01 00 ld      (iy+$01),0                       ; sprite colour
3579: FD 36 00 2D ld      (iy+$00),$2D ; '-'              ; sprite code='POW'
357D: C9          ret
; ---------------------------------------------------------------------------

defer_spawn_timer_357e:                                              ; ...
357E: 3A 00 E0    ld      a,(vblank_tick_e000)
3581: 0F          rrca
3582: E6 7F       and     $7F ; ''
3584: DD 77 08    ld      (ix+$08),a                        ; defer obj spawn timer_e025
3587: DD 34 09    inc     (ix+$09)                           ; ???
358A: C9          ret
; ---------------------------------------------------------------------------
; pointers to tables of pickup types per map_planet_e502
; - 0=POW,1=E,2=S,3=D,4=star
;	.word planet_1_pickup_type_tbl_359d            ; ...
;	.word planet_2_pickup_type_tbl_35ad
;	.word planet_3_pickup_type_tbl_35bd
;	.word planet_4_pickup_type_tbl_35cd
;	.word planet_5_pickup_type_tbl_35dd
;	.word planet_6_pickup_type_tbl_35ed
;	.word planet_7_pickup_type_tbl_35fd
;	.word planet_8_pickup_type_tbl_360d
;	.word planet_9_pickup_type_tbl_361d
; ---------------------------------------------------------------------------

update_active_pickup_362d:                                           ; ...
362D: CD 47 29    call    scroll_ground_object_with_gnd_2947

; =============== S U B R O U T I N E =======================================


handle_pickup_3630:                                                  ; ...
3630: FD 7E 02    ld      a,(iy+$02)                        ; sprite y
3633: FE 10       cp      16                             ; off-screen?
3635: DA E2 36    jp      C,pickup_off_screen_36e2            ; yes,go
3638: FD 7E 03    ld      a,(iy+$03)                        ; sprite x
363B: FE FC       cp      252                            ; off-screen?
363D: D2 E2 36    jp      NC,pickup_off_screen_36e2           ; yes,go
3640: DD 7E 05    ld      a,(ix+$05)
3643: A7          and     a
3644: 28 14       jr      Z,check_pickup_365a
3646: FE 04       cp      4
3648: 20 1B       jr      NZ,loc_3665
364A: 3A 00 E0    ld      a,(vblank_tick_e000)
364D: 0F          rrca
364E: E6 03       and     3
3650: 21 56 36    ld      hl,pickup_sprite_colour_tbl_3656
3653: E7          rst     content_hl_plus_a_0020
3654: 18 0C       jr      loc_3662
; End of function handle_pickup_3630

; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR process_q_02bd

check_pickup_365a:                                                   ; ...
365A: 3A 00 E0    ld      a,(vblank_tick_e000)
365D: 0F          rrca
365E: E6 03       and     3
3660: C6 02       add     a,2                           ; generate sprite colour

loc_3662:                                                       ; ...
3662: FD 77 01    ld      (iy+$01),a                        ; sprite colour

loc_3665:                                                       ; ...
3665: 3A 02 EF    ld      a,(spriteram_shadow_ef00+2)         ; s0.y
3668: FD 96 02    sub     (iy+$02)                           ; compare obj y
366B: C6 08       add     a,8
366D: FE 11       cp      17                             ; match?
366F: D0          ret     NC                              ; no,exit
3670: 3A 03 EF    ld      a,(spriteram_shadow_ef00+3)         ; s0.x
3673: FD 96 03    sub     (iy+$03)                           ; compare obj x
3676: C6 08       add     a,8
3678: FE 11       cp      17                             ; match?
367A: D0          ret     NC                              ; no,exit
367B: 1E 01       ld      e,1                           ; 10 pts
367D: 16 08       ld      d,8                           ; add to score,update hi
367F: FF          rst     add_fn_to_q_0038
3680: DD 36 00 00 ld      (ix+$00),0                       ; obj state=inactive
3684: DD 34 09    inc     (ix+$09)                           ; ???
3687: DD 7E 05    ld      a,(ix+$05)                        ; type
368A: F7          rst    $30			  ; [jump_to_jump_table] [nb_entries=5]
; ---------------------------------------------------------------------------
	.word collect_pow_36ca
	.word collect_letter_3695                      ; 'E'
	.word collect_letter_3695                      ; 'S'
	.word collect_letter_3695                      ; 'D'
	.word collect_star_36a5
; ---------------------------------------------------------------------------

collect_letter_3695:                                                 ; ...
3695: FD 36 02 00 ld      (iy+$02),0                       ; sprite y=0
3699: 3A 00 E0    ld      a,(vblank_tick_e000)
369C: E6 3F       and     $3F ; '?'
369E: DD 77 08    ld      (ix+$08),a                        ; ???
36A1: CD 13 47    call    play_pickup_snd_4713
36A4: C9          ret
; END OF FUNCTION CHUNK FOR process_q_02bd
; ---------------------------------------------------------------------------

collect_star_36a5:                                                   ; ...
36A5: 1E 12       ld      e,18                          ; 10,000 pts
36A7: 16 08       ld      d,8                           ; add to score,update hi
36A9: FF          rst     add_fn_to_q_0038
36AA: CD 13 47    call    play_pickup_snd_4713
36AD: CD 91 2A    call    rand_2a91
36B0: E6 7F       and     $7F ; ''
36B2: DD 77 08    ld      (ix+$08),a
36B5: DD 36 00 3F ld      (ix+$00),$3F ; '?'              ; state
36B9: FD 7E 02    ld      a,(iy+$02)                        ; sprite y
36BC: C6 F8       add     a,$F8 ; '�'                  ; -8
36BE: FD 77 02    ld      (iy+$02),a                        ; update sprite y
36C1: FD 36 00 2E ld      (iy+$00),$2E ; '.'              ; code
36C5: FD 36 01 44 ld      (iy+$01),$44 ; 'D'              ; colour
36C9: C9          ret
; ---------------------------------------------------------------------------

collect_pow_36ca:                                                    ; ...
36CA: FD 36 02 00 ld      (iy+$02),0                       ; sprite y=0
36CE: 21 06 E5    ld      hl,curr_num_bombs_e506
36D1: 34          inc     (hl)                            ; add a bomb
36D2: 11 00 0D    ld      de,$D00                      ; print bombs
36D5: FF          rst     add_fn_to_q_0038
36D6: CD 13 47    call    play_pickup_snd_4713
36D9: CD 91 2A    call    rand_2a91
36DC: E6 7F       and     $7F ; ''
36DE: DD 77 08    ld      (ix+$08),a
36E1: C9          ret
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR process_q_02bd

pickup_off_screen_36e2:                                              ; ...
36E2: CD 91 2A    call    rand_2a91
36E5: DD 77 08    ld      (ix+$08),a
36E8: DD 36 00 00 ld      (ix+$00),0                       ; deactivate object
36EC: FD 36 02 00 ld      (iy+$02),0                       ; sprite y=0
36F0: DD 7E 05    ld      a,(ix+$05)
36F3: A7          and     a
36F4: C8          ret     Z
36F5: FE 04       cp      4
36F7: C8          ret     Z
36F8: F7          rst    $30		  ; [jump_to_jump_table] [nb_entries=4]
; ---------------------------------------------------------------------------
	.word missed_e_3701                            ; unused
	.word missed_e_3701                            ; 'E'
	.word missed_s_370c                            ; 'S'
	.word missed_d_3717                            ; 'D'
; ---------------------------------------------------------------------------
; increases the frequency of spawning flying aliens
; - if you miss one!

missed_e_3701:                                                       ; ...
3701: 3A B8 E0    ld      a,(area_spawn_flying_threshold_adjust_e0b8)
3704: FE 09       cp      9                              ; max?
3706: D0          ret     NC                              ; yes,exit
3707: 3C          inc     a
3708: 32 B8 E0    ld      (area_spawn_flying_threshold_adjust_e0b8),a
370B: C9          ret
; END OF FUNCTION CHUNK FOR process_q_02bd
; ---------------------------------------------------------------------------
; despite claims in the vulgus manual on Capcom Arcade Stadium on the Nintendo Switch
; this appears to be completely benign (in mame set 'vulgusa')

missed_s_370c:                                                       ; ...
370C: 3A CA E0    ld      a,(missed_s_cnt_e0ca)
370F: FE 04       cp      4                              ; max?
3711: D0          ret     NC                              ; yes,exit
3712: 3C          inc     a
3713: 32 CA E0    ld      (missed_s_cnt_e0ca),a
3716: C9          ret
; ---------------------------------------------------------------------------
; increases the maximum number of alien bullets on the screen

missed_d_3717:                                                       ; ...
3717: 3A A4 E0    ld      a,(area_max_alien_bullets_e0a4)
371A: FE 06       cp      6                              ; max?
371C: D0          ret     NC                              ; yes,exit
371D: 3C          inc     a
371E: 32 A4 E0    ld      (area_max_alien_bullets_e0a4),a
3721: C9          ret

; =============== S U B R O U T I N E =======================================


spawn_large_alien_3722:                                              ; ...
3722: 3A C1 E0    ld      a,(area_large_alien_obj_cnt_e0c1)
3725: A7          and     a                               ; none?
3726: C8          ret     Z                               ; yes,exit
3727: 3D          dec     a                               ; convert to 0-based object number
3728: 6F          ld      l,a                            ; save obj 
3729: 5F          ld      e,a                            ; save obj 
372A: 3A C4 E0    ld      a,(large_alien_spawn_tmr_e0c4)
372D: A7          and     a                               ; expired?
372E: C0          ret     NZ                              ; no,exit
372F: 3A 00 E1    ld      a,(ship_obj_e100)
3732: 3C          inc     a                               ; active?
3733: C0          ret     NZ                              ; no,return
3734: DD 21 60 E1 ld      ix,large_alien_obj_tbl_e160

loc_3738:                                                       ; s2.code
3738: FD 21 08 EF ld      iy,spriteram_shadow_ef00+8
; End of function spawn_large_alien_3722

373C: 26 00       ld      h,0
373E: 16 00       ld      d,0
3740: 29          add     hl,hl                          ; x2
3741: 29          add     hl,hl                          ; x4
3742: 29          add     hl,hl                          ; x8
3743: 29          add     hl,hl                          ; x16
3744: EB          ex      de,hl
3745: DD 19       add     ix,de                          ; calc addr alien obj
3747: DD 7E 00    ld      a,(ix+$00)                        ; state
374A: A7          and     a                               ; inactive?
374B: C0          ret     NZ                              ; no,exit
374C: 29          add     hl,hl                          ; x2
374D: 29          add     hl,hl                          ; x4
374E: 29          add     hl,hl                          ; x8
374F: EB          ex      de,hl
3750: FD 19       add     iy,de                          ; calc addr alien sprite
3752: 3A C3 E0    ld      a,(byte_e0c3)
3755: E6 07       and     7
3757: DD 77 0B    ld      (ix+$0B),a
375A: DD 36 0C 00 ld      (ix+$0C),0
375E: DD 36 0D 00 ld      (ix+$0D),0
3762: DD 36 00 FF ld      (ix+$00),$FF                    ; init state=active
3766: 21 94 37    ld      hl,large_alien_sprite_yx_tbl_3794
3769: 87          add     a,a                            ; x2
376A: E7          rst     content_hl_plus_a_0020               ; 1st byte
376B: FD 77 02    ld      (iy+$02),a                        ; init sprite y
376E: 23          inc     hl
376F: 7E          ld      a,(hl)                         ; 2nd byte
3770: FD 77 03    ld      (iy+$03),a                        ; init sprite x
3773: 3A C2 E0    ld      a,(area_large_alien_type_e0c2)      ; alien type from map data
3776: DD 77 05    ld      (ix+$05),a                        ; init type
3779: DD 36 02 00 ld      (ix+$02),0                       ; init hit count
377D: DD 36 0A 05 ld      (ix+$0a),5                     ; dy_dx lookup entry index?
3781: FD 36 01 40 ld      (iy+$01),$40 ; '@'              ; sn.colour
3785: FD 36 05 40 ld      (iy+$05),$40 ; '@'              ; s(n+1).colour
3789: 3A C0 E0    ld      a,(area_large_alien_spawn_tmr_init_e0c0)
378C: 32 C4 E0    ld      (large_alien_spawn_tmr_e0c4),a      ; re-init spawn timer_e025
378F: 21 C1 E0    ld      hl,area_large_alien_obj_cnt_e0c1
3792: 35          dec     (hl)                            ; --
3793: C9          ret
; ---------------------------------------------------------------------------
; sprite y,x

; =============== S U B R O U T I N E =======================================


update_large_aliens_37a4:                                            ; ...

; FUNCTION CHUNK AT ROM:3AA8 SIZE 00000011 BYTES

37A4: FD 21 08 EF ld      iy,spriteram_shadow_ef00+8        ; set s2.code as base
37A8: DD 21 60 E1 ld      ix,large_alien_obj_tbl_e160
37AC: 06 03       ld      b,3                           ; 3 objects to check

loc_37ae:                                                       ; ...
37AE: C5          push    bc
37AF: DD 7E 00    ld      a,(ix+$00)                        ; obj state
37B2: A7          and     a                               ; inactive?
37B3: 28 0A       jr      Z,loc_37bf                     ; yes,skip
37B5: 21 BF 37    ld      hl,loc_37bf			; [push_function]
37B8: E5          push    hl                              ; save return address
37B9: 3C          inc     a                               ; active?
37BA: 28 10       jr      Z,loc_37cc                     ; yes,go
37BC: C3 B9 3A    jp      check_large_alien_hit_3ab9
; ---------------------------------------------------------------------------

loc_37bf:                                                       ; ...
37BF: C1          pop     bc
37C0: 11 08 00    ld      de,8
37C3: FD 19       add     iy,de                          ; sprite += 2
37C5: DD 19       add     ix,de
37C7: DD 19       add     ix,de                          ; next obj
37C9: 10 E3       djnz    loc_37ae                        ; loop
37CB: C9          ret
; ---------------------------------------------------------------------------

loc_37cc:                                                       ; ...
37CC: FD 7E 03    ld      a,(iy+$03)                        ; sprite x
37CF: FE FC       cp      252                            ; off-screen?
37D1: D2 A8 3A    jp      NC,hide_large_alien_3aa8            ; yes,go
37D4: FD 7E 02    ld      a,(iy+$02)                        ; sprite y
37D7: C6 10       add     a,16
37D9: FE 04       cp      4                              ; off-screen?
37DB: DA A8 3A    jp      C,hide_large_alien_3aa8             ; yes,go
37DE: CD 04 38    call    sub_3804
37E1: CD EB 37    call    update_2nd_sprite_37eb
37E4: CD EE 39    call    animate_big_alien_39ee
37E7: CD BA 2A    call    handle_large_alien_bullets_2aba
37EA: C9          ret
; End of function update_large_aliens_37a4


; =============== S U B R O U T I N E =======================================


update_2nd_sprite_37eb:                                              ; ...
37EB: FD 7E 02    ld      a,(iy+$02)                        ; sn.y
37EE: FD 77 06    ld      (iy+$06),a                        ; copy to s(n+1).y
37F1: C6 08       add     a,8                           ; calc rock spawn y msb
37F3: 32 CD E0    ld      (related_to_big_alien_y_e0cd),a     ; store
37F6: FD 7E 03    ld      a,(iy+$03)                        ; sn.x
37F9: C6 F8       add     a,-8                          ; calc rock spawn x msb
37FB: 32 CE E0    ld      (related_to_big_alien_x_e0ce),a     ; store
37FE: C6 18       add     a,24                          ; +24(=sn.x+16)
3800: FD 77 07    ld      (iy+$07),a                        ; s(n+1).x
3803: C9          ret
; End of function update_2nd_sprite_37eb


; =============== S U B R O U T I N E =======================================


sub_3804:                                                       ; ...
3804: DD 7E 0D    ld      a,(ix+$0D)
3807: A7          and     a
3808: CC AB 38    call    Z,sub_38ab
380B: DD 35 0D    dec     (ix+$0D)
380E: C3 3B 24    jp      move_object_self_243b
; End of function sub_3804

; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR sub_38ab

loc_3811:                                                       ; ...
3811: DD 7E 0C    ld      a,(ix+$0C)
3814: DD 34 0C    inc     (ix+$0C)
3817: CB 47       bit     0,a
3819: 20 55       jr      NZ,loc_3870
381B: E6 1E       and     $1E
381D: 21 85 38    ld      hl,byte_3885
3820: E7          rst     content_hl_plus_a_0020
3821: FD 96 02    sub     (iy+$02)                           ; sub sprite y
3824: 57          ld      d,a
3825: 1E 00       ld      e,0
3827: CB 1A       rr      d
3829: CB 1B       rr      e
382B: CB 2A       sra     d
382D: CB 1B       rr      e
382F: CB 2A       sra     d
3831: CB 1B       rr      e
3833: CB 2A       sra     d
3835: CB 1B       rr      e
3837: CB 2A       sra     d
3839: CB 1B       rr      e
383B: CB 2A       sra     d
383D: CB 1B       rr      e
383F: DD 72 06    ld      (ix+$06),d
3842: DD 73 07    ld      (ix+$07),e
3845: 23          inc     hl
3846: 7E          ld      a,(hl)
3847: FD 96 03    sub     (iy+$03)
384A: 57          ld      d,a
384B: 1E 00       ld      e,0
384D: CB 1A       rr      d
384F: CB 1B       rr      e
3851: CB 2A       sra     d
3853: CB 1B       rr      e
3855: CB 2A       sra     d
3857: CB 1B       rr      e
3859: CB 2A       sra     d
385B: CB 1B       rr      e
385D: CB 2A       sra     d
385F: CB 1B       rr      e
3861: CB 2A       sra     d
3863: CB 1B       rr      e
3865: DD 72 08    ld      (ix+$08),d
3868: DD 73 09    ld      (ix+$09),e
386B: DD 36 0D 40 ld      (ix+$0D),$40 ; '@'
386F: C9          ret
; ---------------------------------------------------------------------------

loc_3870:                                                       ; ...
3870: DD 36 06 00 ld      (ix+$06),0
3874: DD 36 07 00 ld      (ix+$07),0
3878: DD 36 08 00 ld      (ix+$08),0
387C: DD 36 09 00 ld      (ix+$09),0
3880: DD 36 0D 3C ld      (ix+$0D),$3C ; '<'
3884: C9          ret
; END OF FUNCTION CHUNK FOR sub_38ab
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================


sub_38ab:                                                       ; ...

; FUNCTION CHUNK AT ROM:3811 SIZE 00000074 BYTES

38AB: DD 7E 05    ld      a,(ix+$05)                        ; obj type
38AE: FE 03       cp      3
38B0: D2 11 38    jp      NC,loc_3811
38B3: 21 0A 39    ld      hl,off_390a
38B6: DD 7E 0B    ld      a,(ix+$0B)
38B9: FE FF       cp      $FF
38BB: C8          ret     Z
38BC: EF          rst     de_eq_contents_hl_plus_2a_0028
38BD: EB          ex      de,hl
38BE: DD 7E 0C    ld      a,(ix+$0C)
38C1: DD 34 0C    inc     (ix+$0C)
38C4: 87          add     a,a
38C5: E7          rst     content_hl_plus_a_0020
38C6: FE FF       cp      $FF
38C8: 28 0F       jr      Z,loc_38d9
38CA: FE FE       cp      $FE ; '�'
38CC: 28 2A       jr      Z,loc_38f8
38CE: DD 77 01    ld      (ix+$01),a
38D1: 23          inc     hl
38D2: 7E          ld      a,(hl)
38D3: DD 77 0D    ld      (ix+$0D),a
38D6: C3 98 28    jp      lookup_dy_dx_store_2898
; ---------------------------------------------------------------------------

loc_38d9:                                                       ; ...
38D9: 23          inc     hl
38DA: 7E          ld      a,(hl)
38DB: FE FF       cp      $FF
38DD: CA F1 38    jp      Z,loc_38f1
38E0: DD 77 0D    ld      (ix+$0D),a
38E3: AF          xor     a
38E4: DD 77 06    ld      (ix+$06),a
38E7: DD 77 07    ld      (ix+$07),a
38EA: DD 77 08    ld      (ix+$08),a
38ED: DD 77 09    ld      (ix+$09),a
38F0: C9          ret
; ---------------------------------------------------------------------------

loc_38f1:                                                       ; ...
38F1: DD 36 0B FF ld      (ix+$0B),$FF
38F5: C3 98 28    jp      lookup_dy_dx_store_2898
; ---------------------------------------------------------------------------

loc_38f8:                                                       ; ...
38F8: 23          inc     hl
38F9: 7E          ld      a,(hl)
38FA: EB          ex      de,hl
38FB: 21 07 39    ld      hl,byte_3907
38FE: E7          rst     content_hl_plus_a_0020
38FF: DD 77 0A    ld      (ix+$0a),a
3902: DD 36 0D 01 ld      (ix+$0D),1
3906: C9          ret
; End of function sub_38ab

; ---------------------------------------------------------------------------
;	.word byte_391a                           ; ...
;	.word byte_3932
;	.word byte_3950
;	.word byte_396a
;	.word byte_3978
;	.word byte_3994
;	.word byte_39a8
;	.word byte_39e0

; =============== S U B R O U T I N E =======================================


animate_big_alien_39ee:                                              ; ...
39EE: DD 7E 05    ld      a,(ix+$05)                        ; type
39F1: F7          rst    $30			  ; [jump_to_jump_table] [nb_entries=5]
; End of function animate_big_alien_39ee

; ---------------------------------------------------------------------------
	.word animate_viking_39fc
	.word animate_fly_3a37
	.word animate_bat_3a56
	.word set_vulgus_code_colour_3a9c
	.word set_vulgus_sprite_code_3a80
; ---------------------------------------------------------------------------

animate_viking_39fc:                                                 ; ...
39FC: DD 7E 02    ld      a,(ix+$02)                        ; hit count?
39FF: FE 05       cp      5
3A01: 28 18       jr      Z,animate_viking_hit_3a1b
3A03: 3A 00 E0    ld      a,(vblank_tick_e000)
3A06: 47          ld      b,a
3A07: E6 08       and     8
3A09: C6 40       add     a,$40 ; '@'
3A0B: FD 77 01    ld      (iy+$01),a                        ; sn.solour
3A0E: FD 36 00 C8 ld      (iy+$00),$C8 ; '�'              ; sn.code=viking (bottom)
3A12: 78          ld      a,b
3A13: E6 10       and     $10
3A15: C6 C0       add     a,$C0 ; '�'                  ; calc code
3A17: FD 77 04    ld      (iy+$04),a                        ; s(n+1).code=viking (top)
3A1A: C9          ret
; ---------------------------------------------------------------------------

animate_viking_hit_3a1b:                                             ; ...
3A1B: 3A 00 E0    ld      a,(vblank_tick_e000)
3A1E: 47          ld      b,a
3A1F: E6 04       and     4
3A21: C6 49       add     a,$49 ; 'I'
3A23: FD 77 01    ld      (iy+$01),a                        ; sn.colour
3A26: FD 36 00 C8 ld      (iy+$00),$C8 ; '�'              ; s0.code=viking (bottom)
3A2A: 78          ld      a,b
3A2B: E6 10       and     $10
3A2D: C6 C0       add     a,$C0 ; '�'                  ; calc code
3A2F: FD 77 04    ld      (iy+$04),a                        ; s(n+1).code=viking (top)
3A32: FD 36 05 49 ld      (iy+$05),$49 ; 'I'              ; s(n+1).colour
3A36: C9          ret
; ---------------------------------------------------------------------------

animate_fly_3a37:                                                    ; ...
3A37: 3A 00 E0    ld      a,(vblank_tick_e000)
3A3A: 47          ld      b,a
3A3B: E6 10       and     $10
3A3D: C6 C2       add     a,$C2 ; '�'                  ; calc code
3A3F: FD 77 04    ld      (iy+$04),a                        ; s(n+1).code
3A42: C6 08       add     a,8                           ; calc code
3A44: FD 77 00    ld      (iy+$00),a                        ; sn.code
3A47: DD 7E 02    ld      a,(ix+$02)                        ; hit count
3A4A: FE 05       cp      5                              ; hit 5 times?
3A4C: D8          ret     C                               ; no,exit
3A4D: FD 36 01 49 ld      (iy+$01),$49 ; 'I'              ; sn.colour
3A51: FD 36 05 49 ld      (iy+$05),$49 ; 'I'              ; s(n+1).colour
3A55: C9          ret
; ---------------------------------------------------------------------------

animate_bat_3a56:                                                    ; ...
3A56: 21 78 3A    ld      hl,bat_sprite_code_tbl_3a78
3A59: 3A 00 E0    ld      a,(vblank_tick_e000)
3A5C: 0F          rrca
3A5D: 0F          rrca
3A5E: E6 07       and     7
3A60: E7          rst     content_hl_plus_a_0020
3A61: FD 77 04    ld      (iy+$04),a                        ; s(n+1).code
3A64: C6 08       add     a,8                           ; calc code
3A66: FD 77 00    ld      (iy+$00),a                        ; sn.code
3A69: DD 7E 02    ld      a,(ix+$02)                        ; hit count
3A6C: FE 05       cp      5                              ; hit 5 times?
3A6E: D8          ret     C                               ; no,exit
3A6F: FD 36 01 49 ld      (iy+$01),$49 ; 'I'              ; sn.colour
3A73: FD 36 05 49 ld      (iy+$05),$49 ; 'I'              ; s(n+1).colour
3A77: C9          ret
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------

set_vulgus_sprite_code_3a80:                                         ; ...
3A80: 21 94 3A    ld      hl,vulgus_sprite_tbl_3a94
3A83: 3A 00 E0    ld      a,(vblank_tick_e000)
3A86: 0F          rrca
3A87: 0F          rrca
3A88: E6 07       and     7                              ; sprite code entry index
3A8A: E7          rst     content_hl_plus_a_0020               ; get code entry
3A8B: FD 77 04    ld      (iy+$04),a                        ; update s(n+1).code
3A8E: C6 08       add     a,8                           ; calc sprite code
3A90: FD 77 00    ld      (iy+$00),a                        ; update sn.code
3A93: C9          ret
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------

set_vulgus_code_colour_3a9c:                                         ; ...
3A9C: CD 80 3A    call    set_vulgus_sprite_code_3a80
3A9F: FD 36 01 46 ld      (iy+$01),$46 ; 'F'              ; sn.colour
3AA3: FD 36 05 46 ld      (iy+$05),$46 ; 'F'              ; s(n+1).colour
3AA7: C9          ret
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR update_large_aliens_37a4

hide_large_alien_3aa8:                                               ; ...
3AA8: AF          xor     a
3AA9: FD 77 02    ld      (iy+$02),a                        ; sn.y=0
3AAC: FD 77 06    ld      (iy+$06),a                        ; s(n+1).y=0
3AAF: FD 77 01    ld      (iy+$01),a                        ; sn.colour=0
3AB2: FD 77 05    ld      (iy+$05),a                        ; s(n+1).colour=0
3AB5: DD 77 00    ld      (ix+$00),a                        ; inactive
3AB8: C9          ret
; END OF FUNCTION CHUNK FOR update_large_aliens_37a4

; =============== S U B R O U T I N E =======================================


check_large_alien_hit_3ab9:                                          ; ...
3AB9: FE 6F       cp      $6F ; 'o'                     ; state=?
3ABB: D2 30 3B    jp      NC,hit_large_alien_3b30
3ABE: CD 96 3B    call    update_large_alien_for_bg_movement_3b96
3AC1: DD 7E 02    ld      a,(ix+$02)                        ; hit count
3AC4: A7          and     a                               ; hit?
3AC5: 28 04       jr      Z,large_alien_explode_3acb          ; no,go
3AC7: DD 35 02    dec     (ix+$02)                           ; ???
3ACA: C9          ret
; ---------------------------------------------------------------------------

large_alien_explode_3acb:                                            ; ...
3ACB: DD 7E 01    ld      a,(ix+$01)                        ; frame count
3ACE: DD 34 01    inc     (ix+$01)
3AD1: 21 86 3B    ld      hl,large_alien_explosion_tbl_3b86
3AD4: 87          add     a,a                            ; calc entry offset
3AD5: E7          rst     content_hl_plus_a_0020               ; get entry
3AD6: FD 77 04    ld      (iy+$04),a                        ; s(n+1).code
3AD9: 47          ld      b,a                            ; store
3ADA: C6 08       add     a,8                           ; calc code
3ADC: FD 77 00    ld      (iy+$00),a                        ; sn.code
3ADF: 23          inc     hl                              ; next entry byte
3AE0: 7E          ld      a,(hl)
3AE1: DD 77 02    ld      (ix+$02),a                        ; hit count???
3AE4: 78          ld      a,b                            ; restore code
3AE5: FE FF       cp      $FF                           ; end of table?
3AE7: 28 BF       jr      Z,hide_large_alien_3aa8             ; yes,go
3AE9: FE 36       cp      $36 ; '6'                     ; score?
3AEB: C0          ret     NZ                              ; no,exit
3AEC: FD 7E 06    ld      a,(iy+$06)                        ; s(n+1).y
3AEF: C6 08       add     a,8                           ; move
3AF1: FD 77 06    ld      (iy+$06),a                        ; adjust
3AF4: FD 7E 07    ld      a,(iy+$07)                        ; s(n+1).x
3AF7: D6 08       sub     8                              ; adjust
3AF9: FD 77 07    ld      (iy+$07),a                        ; s(n+1).x
3AFC: FD 36 00 FF ld      (iy+$00),$FF                    ; sn.code=blank
3B00: FD 36 05 00 ld      (iy+$05),0                       ; s(n+1).colour
3B04: FD 36 01 00 ld      (iy+$01),0                       ; sn.colour
3B08: DD 7E 05    ld      a,(ix+$05)                        ; object type
3B0B: FE 03       cp      3                              ; vulgus_hit?
3B0D: D8          ret     C                               ; yes,exit
; vulgus explode
3B0E: FD 36 04 2E ld      (iy+$04),$2E ; '.'              ; s(n+1).code="10,000"
3B12: FD 36 05 40 ld      (iy+$05),$40 ; '@'              ; s(n+1).colour
3B16: 21 1F E0    ld      hl,byte_e01f
3B19: 34          inc     (hl)
3B1A: 3A 08 E5    ld      a,(bomb_fired__maybe_e508)
3B1D: A7          and     a
3B1E: C0          ret     NZ
3B1F: FD 36 04 C6 ld      (iy+$04),$C6 ; '�'              ; s(n+1).code="50,000"
3B23: C9          ret
; ---------------------------------------------------------------------------

hit_vulgus_3b24:                                                     ; ...
3B24: DD 34 05    inc     (ix+$05)                           ; 4=vulgus hit
3B27: DD 36 00 FF ld      (ix+$00),$FF                    ; activate object
3B2B: DD 36 02 00 ld      (ix+$02),0                       ; timer_e025/hit count?
3B2F: C9          ret
; ---------------------------------------------------------------------------

hit_large_alien_3b30:                                                ; ...
3B30: FD 36 01 40 ld      (iy+$01),$40 ; '@'              ; sn.colour
3B34: FD 36 05 40 ld      (iy+$05),$40 ; '@'              ; s(n+1).colour
3B38: DD 7E 02    ld      a,(ix+$02)                        ; hit counter
3B3B: FE 06       cp      6                              ; hit 6 times?
3B3D: 38 3B       jr      C,score_50_pts_3b7a                 ; no,go
3B3F: DD 7E 05    ld      a,(ix+$05)                        ; obj type
3B42: FE 03       cp      3                              ; vulgus?
3B44: 28 DE       jr      Z,hit_vulgus_3b24                   ; yes,go
3B46: DD 36 00 01 ld      (ix+$00),1                       ; obj state=1
3B4A: DD 36 01 00 ld      (ix+$01),0                       ; obj counter
3B4E: DD 36 02 00 ld      (ix+$02),0                       ; obj timer_e025
3B52: DD 7E 05    ld      a,(ix+$05)                        ; obj type
3B55: FE 03       cp      3                              ; vulgus (already hit)?
3B57: 30 09       jr      NC,score_10_or_50_000_pts_3b62      ; yes,go
3B59: 16 08       ld      d,8                           ; add to score,update hi
3B5B: 1E 08       ld      e,8                           ; 1,000 pts
3B5D: FF          rst     add_fn_to_q_0038
3B5E: CD 8D 47    call    snd_cmd_02_478d
3B61: C9          ret
; ---------------------------------------------------------------------------

score_10_or_50_000_pts_3b62:                                         ; ...
3B62: 16 08       ld      d,8
3B64: 1E 12       ld      e,18                          ; 10,000 pts
3B66: 3A 08 E5    ld      a,(bomb_fired__maybe_e508)
3B69: A7          and     a
3B6A: 20 01       jr      NZ,loc_3b6d
3B6C: 1C          inc     e                               ; 50,000 pts

loc_3b6d:                                                       ; ...
3B6D: FF          rst     add_fn_to_q_0038
3B6E: CD 8D 47    call    snd_cmd_02_478d
3B71: 21 00 E5    ld      hl,curr_lives_left_e500
3B74: 34          inc     (hl)                            ; extra life
3B75: 11 00 09    ld      de,$900                      ; show lives ships
3B78: FF          rst     add_fn_to_q_0038
3B79: C9          ret
; ---------------------------------------------------------------------------

score_50_pts_3b7a:                                                   ; ...
3B7A: 16 08       ld      d,8                           ; add to score,update hi
3B7C: 1E 00       ld      e,0                           ; 50 pts
3B7E: FF          rst     add_fn_to_q_0038
3B7F: DD 36 00 FF ld      (ix+$00),$FF                    ; (re)activate object
3B83: C3 7D 47    jp      snd_cmd_03_477d
; End of function check_large_alien_hit_3ab9

; ---------------------------------------------------------------------------
; sprite code,??? (large aliens) (hit count??)

; =============== S U B R O U T I N E =======================================


update_large_alien_for_bg_movement_3b96:                             ; ...
3B96: FD 56 02    ld      d,(iy+$02)                        ; sn.y
3B99: DD 5E 03    ld      e,(ix+$03)                        ; obj y lsb
3B9C: 2A 09 E1    ld      hl,(airborne_dy_e109)
3B9F: 19          add     hl,de                          ; move w/bg
3BA0: FD 74 02    ld      (iy+$02),h                        ; update sn.y
3BA3: FD 74 06    ld      (iy+$06),h                        ; update s(n+1).y
3BA6: DD 75 03    ld      (ix+$03),l                        ; update obj y lsb
3BA9: FD 66 07    ld      h,(iy+$07)                        ; s(n+1).x
3BAC: DD 6E 04    ld      l,(ix+$04)                        ; obj x lsb
3BAF: 11 80 FF    ld      de,-128
3BB2: 19          add     hl,de                          ; calc sprite (n+1).x
3BB3: FD 74 07    ld      (iy+$07),h                        ; update s(n+1).x
3BB6: DD 75 04    ld      (ix+$04),l                        ; update obj x lsb
3BB9: 7C          ld      a,h
3BBA: D6 10       sub     16                             ; calc sprite x
3BBC: FD 77 03    ld      (iy+$03),a                        ; update sn.x
3BBF: C9          ret
; End of function update_large_alien_for_bg_movement_3b96

; *** NOT USED IN ATTRACT MODE

; =============== S U B R O U T I N E =======================================


spawn_e300_objects_3bc0:                                             ; ...
3BC0: 3A B5 E0    ld      a,(area_non_firing_alien_type_1_based_e0b5)
3BC3: A7          and     a                               ; valid?
3BC4: C8          ret     Z                               ; no,exit
3BC5: 3A B4 E0    ld      a,(spawn_non_firing_tmr_e0b4)       ; *** ALWAYS 0
3BC8: A7          and     a                               ; expired?
3BC9: C0          ret     NZ                              ; no,exit
3BCA: FD 21 10 EF ld      iy,spriteram_shadow_ef00+0x10     ; set s4.code as base
3BCE: DD 21 00 E3 ld      ix,e300_obj_tbl_e300
3BD2: 26 04       ld      h,4                           ;  objs to check
3BD4: 3A 02 E5    ld      a,(map_planet_e502)
3BD7: A7          and     a
3BD8: 20 01       jr      NZ,loc_3bdb
3BDA: 25          dec     h                               ; adj  objs

loc_3bdb:                                                       ; ...
3BDB: 11 10 00    ld      de,$10                       ; bytes per obj
3BDE: 01 04 00    ld      bc,4                          ; bytes per sprite

loc_3be1:                                                       ; ...
3BE1: DD 7E 00    ld      a,(ix+$00)                        ; obj state
3BE4: A7          and     a                               ; inactive?
3BE5: 28 08       jr      Z,spawn_non_firing_and_init_tmr_3bef ; yes,go
3BE7: DD 19       add     ix,de                          ; next obj
3BE9: FD 09       add     iy,bc                          ; next sprite
3BEB: 25          dec     h
3BEC: 20 F3       jr      NZ,loc_3be1                    ; loop
3BEE: C9          ret
; ---------------------------------------------------------------------------

spawn_non_firing_and_init_tmr_3bef:                                  ; ...
3BEF: CD F9 3B    call    spawn_e300_object_3bf9
; *** THIS IS NEVER EXPLICITLY INITIALISED!!!
; - cleared to 0 at program init,so TMR is always 0!!
3BF2: 3A B3 E0    ld      a,(init_spawn_non_firing_tmr_init_e0b3)
3BF5: 32 B4 E0    ld      (spawn_non_firing_tmr_e0b4),a
3BF8: C9          ret
; End of function spawn_e300_objects_3bc0


; =============== S U B R O U T I N E =======================================


spawn_e300_object_3bf9:                                              ; ...
3BF9: 3A C9 E0    ld      a,(area_non_firing_alien_type_0_based_e0c9)
3BFC: F7          rst    $30				  ; [jump_to_jump_table] [nb_entries=5]
; End of function spawn_e300_object_3bf9

; ---------------------------------------------------------------------------
	.word spawn_spinning_block_3d5f
	.word spawn_yashichi_3d22
	.word spawn_eyeball_3ccb
	.word spawn_rock_3c73
	.word spawn_spinning_disc_3c07
; ---------------------------------------------------------------------------

spawn_spinning_disc_3c07:                                            ; ...
3C07: CD 91 2A    call    rand_2a91
3C0A: F5          push    af
3C0B: 47          ld      b,a                            ; save
3C0C: E6 3F       and     $3F ; '?'
3C0E: C6 A0       add     a,160                         ; calc rnd x coord
3C10: FD 77 03    ld      (iy+$03),a                        ; init sn.x
3C13: 78          ld      a,b
3C14: CB 2F       sra     a
3C16: CB 2F       sra     a
3C18: CB 2F       sra     a                               ; rnd(0-31)
3C1A: C6 08       add     a,8                           ; rnd(8-29)
3C1C: FD 77 02    ld      (iy+$02),a                        ; init sn.y
3C1F: FD 36 01 00 ld      (iy+$01),0                       ; sn.colour
3C23: DD 36 00 FF ld      (ix+$00),$FF                    ; state=active
3C27: DD 36 01 00 ld      (ix+$01),0                       ; obj counter/flag
3C2B: DD 36 05 07 ld      (ix+$05),7                       ; init type=spinning_disc
3C2F: 21 30 FD    ld      hl,$FD30
3C32: DD 74 08    ld      (ix+$08),h
3C35: DD 75 09    ld      (ix+$09),l                        ; init obj dx
3C38: 21 06 00    ld      hl,6
3C3B: DD 74 0C    ld      (ix+$0C),h
3C3E: DD 75 0D    ld      (ix+$0D),l                      ; init obj ddx
3C41: 3E 01       ld      a,1                           ; dy msb=1
3C43: FD CB 02 7E bit     7,(iy+$02)                        ; sn.y
3C47: 28 02       jr      Z,loc_3c4b                     ; adjust for dir
3C49: 3E FE       ld      a,-2                          ; dy msb=-2

loc_3c4b:                                                       ; ...
3C4B: DD 77 06    ld      (ix+$06),a                        ; init obj dy msb
3C4E: F1          pop     af                              ; rnd
3C4F: DD 77 07    ld      (ix+$07),a                        ; init obj dy lsb
3C52: DD 36 0A 00 ld      (ix+$0a),0
3C56: DD 36 0B 00 ld      (ix+$0B),0                     ; zero obj ddy
3C5A: C9          ret
; ---------------------------------------------------------------------------

spawn_e300_rnd_type_012_3c5b:                                        ; ...
3C5B: 3A 00 E0    ld      a,(vblank_tick_e000)
3C5E: 0F          rrca
3C5F: 0F          rrca
3C60: E6 07       and     7
3C62: F7          rst    $30		  ; [jump_to_jump_table] [nb_entries=8]
; ---------------------------------------------------------------------------
	.word spawn_spinning_block_3d5f
	.word spawn_yashichi_3d22
	.word spawn_eyeball_3ccb
	.word spawn_spinning_block_3d5f
	.word spawn_yashichi_3d22
	.word spawn_eyeball_3ccb
	.word spawn_spinning_block_3d5f
	.word spawn_yashichi_3d22
; ---------------------------------------------------------------------------

spawn_rock_3c73:                                                     ; ...
3C73: DD 36 0E 00 ld      (ix+$0E),0
3C77: 3A 60 E1    ld      a,(large_alien_obj_tbl_e160)        ; 1st alien
3C7A: 3C          inc     a                               ; active?
3C7B: 20 DE       jr      NZ,spawn_e300_rnd_type_012_3c5b     ; no,go
3C7D: 3A 65 E1    ld      a,(large_alien_obj_tbl_e160+5)      ; type
3C80: FE 03       cp      3                              ; vulgus?
3C82: 38 D7       jr      C,spawn_e300_rnd_type_012_3c5b      ; no,go
; *** vlugus is active
3C84: DD 36 0E 01 ld      (ix+$0E),1
3C88: 3A 00 E0    ld      a,(vblank_tick_e000)
3C8B: ED 44       neg
3C8D: E6 7F       and     $7F ; ''
3C8F: 87          add     a,a
3C90: 47          ld      b,a
3C91: DD E5       push    ix
3C93: E1          pop     hl
3C94: 7D          ld      a,l
3C95: E6 30       and     $30 ; '0'
3C97: 87          add     a,a
3C98: 87          add     a,a
3C99: 80          add     a,b
3C9A: DD 77 01    ld      (ix+$01),a                        ; obj counter/flag
3C9D: DD 36 00 FF ld      (ix+$00),$FF                    ; state=active
3CA1: DD 36 05 03 ld      (ix+$05),3                       ; init type=rock
3CA5: DD 36 0C D0 ld      (ix+$0C),$D0 ; '�'            ; init ddx msb
3CA9: 3A CD E0    ld      a,(related_to_big_alien_y_e0cd)
3CAC: FD 77 02    ld      (iy+$02),a                        ; init sn.y
3CAF: 3A CE E0    ld      a,(related_to_big_alien_x_e0ce)
3CB2: FD 77 03    ld      (iy+$03),a                        ; init sn.x
3CB5: FD 36 00 FF ld      (iy+$00),$FF                    ; sn.code=blank
3CB9: FD 36 01 00 ld      (iy+$01),0                       ; sn.colour
3CBD: CD 91 2A    call    rand_2a91
3CC0: DD 77 0D    ld      (ix+$0D),a                      ; init ddx lsb
3CC3: DD 77 0B    ld      (ix+$0B),a
3CC6: DD 36 0A 00 ld      (ix+$0a),0                     ; init ddy
3CCA: C9          ret
; ---------------------------------------------------------------------------

spawn_eyeball_3ccb:                                                  ; ...
3CCB: CD 91 2A    call    rand_2a91
3CCE: 47          ld      b,a
3CCF: E6 3F       and     $3F ; '?'
3CD1: C6 A0       add     a,160                         ; calc rnd x
3CD3: FD 77 03    ld      (iy+$03),a                        ; init sn.x
3CD6: 78          ld      a,b
3CD7: CB 2F       sra     a
3CD9: CB 2F       sra     a
3CDB: CB 2F       sra     a                               ; rnd(0-31)
3CDD: C6 08       add     a,8                           ; rnd(8-39)
3CDF: FD 77 02    ld      (iy+$02),a                        ; init sn.y
3CE2: FD 36 00 D8 ld      (iy+$00),$D8 ; '�'              ; code=eyeball
3CE6: FD 36 01 00 ld      (iy+$01),0                       ; sn.colour
3CEA: DD 36 00 FF ld      (ix+$00),$FF                    ; state=active
3CEE: DD 36 01 00 ld      (ix+$01),0                       ; obj counter/flag
3CF2: DD 36 05 02 ld      (ix+$05),2                       ; init type=2
3CF6: 21 30 FD    ld      hl,$FD30
3CF9: DD 74 08    ld      (ix+$08),h
3CFC: DD 75 09    ld      (ix+$09),l                        ; init obj dx
3CFF: 21 06 00    ld      hl,6
3D02: DD 74 0C    ld      (ix+$0C),h
3D05: DD 75 0D    ld      (ix+$0D),l                      ; init obj ddx
3D08: 3E 01       ld      a,1                           ; dy msb=1
3D0A: FD CB 02 7E bit     7,(iy+$02)                        ; sn.y
3D0E: 28 02       jr      Z,loc_3d12                     ; adjust dy dir
3D10: 3E FE       ld      a,-2                          ; dy msb=-2

loc_3d12:                                                       ; ...
3D12: DD 77 06    ld      (ix+$06),a
3D15: DD 36 07 80 ld      (ix+$07),128                     ; init obj dy
3D19: DD 36 0A 00 ld      (ix+$0a),0
3D1D: DD 36 0B 00 ld      (ix+$0B),0                     ; init obj ddy
3D21: C9          ret
; ---------------------------------------------------------------------------

spawn_yashichi_3d22:                                                 ; ...
3D22: FD 36 03 E0 ld      (iy+$03),224                     ; init sn.x
3D26: CD 91 2A    call    rand_2a91
3D29: FD 77 02    ld      (iy+$02),a                        ; init sn.y
3D2C: FD 36 01 00 ld      (iy+$01),0                       ; sn.colour
3D30: DD 36 00 FF ld      (ix+$00),$FF                    ; state=active
3D34: DD 36 01 00 ld      (ix+$01),0                       ; init counter/flag
3D38: DD 36 05 01 ld      (ix+$05),1                       ; init type=1
3D3C: 21 50 FD    ld      hl,$FD50
3D3F: DD 74 08    ld      (ix+$08),h
3D42: DD 75 09    ld      (ix+$09),l                        ; init obj dy
3D45: 21 07 00    ld      hl,7
3D48: DD 74 0C    ld      (ix+$0C),h
3D4B: DD 75 0D    ld      (ix+$0D),l                      ; init obj ddx
3D4E: DD 36 06 00 ld      (ix+$06),0
3D52: DD 36 07 00 ld      (ix+$07),0                       ; init obj dx
3D56: DD 36 0A 00 ld      (ix+$0a),0
3D5A: DD 36 0B 00 ld      (ix+$0B),0                     ; zero obj ddy
3D5E: C9          ret
; ---------------------------------------------------------------------------

spawn_spinning_block_3d5f:                                           ; ...
3D5F: CD 91 2A    call    rand_2a91
3D62: DD 77 0D    ld      (ix+$0D),a                      ; init obj ddx lsb
3D65: E6 1E       and     $1E
3D67: 21 A2 3D    ld      hl,e300_type0_spawn_coords_3da2
3D6A: E7          rst     content_hl_plus_a_0020
3D6B: 47          ld      b,a
3D6C: FD 77 02    ld      (iy+$02),a                        ; init sn.y
3D6F: 23          inc     hl
3D70: 7E          ld      a,(hl)
3D71: FD 77 03    ld      (iy+$03),a                        ; init sn.x
3D74: 21 30 FE    ld      hl,$FE30
3D77: DD 74 08    ld      (ix+$08),h
3D7A: DD 75 09    ld      (ix+$09),l                        ; init obj dx
3D7D: 11 40 02    ld      de,576
3D80: CB 78       bit     7,b
3D82: 28 07       jr      Z,loc_3d8b
3D84: 21 00 00    ld      hl,0
3D87: A7          and     a
3D88: ED 52       sbc     hl,de                          ; adjust sign depending on starting coord
3D8A: EB          ex      de,hl

loc_3d8b:                                                       ; ...
3D8B: DD 72 06    ld      (ix+$06),d
3D8E: DD 73 07    ld      (ix+$07),e                        ; init obj dy
3D91: DD 36 00 FF ld      (ix+$00),$FF                    ; state=active
3D95: DD 36 01 00 ld      (ix+$01),0                       ; counter/flag=0
3D99: DD 36 05 00 ld      (ix+$05),0                       ; type=0
3D9D: FD 36 01 00 ld      (iy+$01),0                       ; sn.colour
3DA1: C9          ret
; ---------------------------------------------------------------------------
; *** NOT USED IN ATTRACT MODE

; =============== S U B R O U T I N E =======================================


update_e300_objects_3dc2:                                            ; ...

; FUNCTION CHUNK AT ROM:3E85 SIZE 00000005 BYTES

3DC2: DD 21 00 E3 ld      ix,e300_obj_tbl_e300
3DC6: FD 21 10 EF ld      iy,spriteram_shadow_ef00+0x10     ; set s4.code as base
3DCA: 06 04       ld      b,4                           ; 4 objs to check

loc_3dcc:                                                       ; ...
3DCC: C5          push    bc
3DCD: DD 7E 00    ld      a,(ix+$00)                        ; obj state
3DD0: A7          and     a                               ; inactive?
3DD1: 28 0B       jr      Z,loc_3dde                     ; yes,skip
3DD3: 21 DE 3D    ld      hl,loc_3dde			; [push_function]
3DD6: E5          push    hl                              ; save return address
3DD7: 3C          inc     a                               ; active?
3DD8: CA 39 3E    jp      Z,animate_active_e300_obj_3e39      ; yes,go
3DDB: C3 EC 3D    jp      animate_exploding_e300_obj_3dec
; ---------------------------------------------------------------------------

loc_3dde:                                                       ; ...
3DDE: 11 10 00    ld      de,$10
3DE1: DD 19       add     ix,de                          ; next object
3DE3: 11 04 00    ld      de,4
3DE6: FD 19       add     iy,de                          ; next sprite
3DE8: C1          pop     bc
3DE9: 10 E1       djnz    loc_3dcc                        ; loop
3DEB: C9          ret
; ---------------------------------------------------------------------------

animate_exploding_e300_obj_3dec:                                     ; ...
3DEC: FE 3F       cp      $3F ; '?'                     ; state=hit?
3DEE: 30 16       jr      NC,loc_3e06                    ; yes,go
3DF0: CD 2B 24    call    check_sprite_off_screen_242b         ; off-screen?
3DF3: DA 90 29    jp      C,deactivate_obj_2990               ; yes,go
3DF6: DD 35 00    dec     (ix+$00)                           ; dec frame counter
3DF9: CA 90 29    jp      Z,deactivate_obj_2990               ; go if done
3DFC: DD 7E 00    ld      a,(ix+$00)                        ; obj state
3DFF: E6 03       and     3                              ; time for next code?
3E01: C0          ret     NZ                              ; no,exit
3E02: FD 34 00    inc     (iy+$00)                           ; inc sprite code
3E05: C9          ret
; ---------------------------------------------------------------------------

loc_3e06:                                                       ; ...
3E06: FE 6F       cp      $6F ; 'o'                     ; ??
3E08: 30 08       jr      NC,start_100pts_exploding_3e12
3E0A: DD 7E 01    ld      a,(ix+$01)                        ; obj counter/flag
3E0D: FE 02       cp      2
3E0F: CA 31 3E    jp      Z,activate_obj_play_snd_3_3e31

start_100pts_exploding_3e12:                                         ; ...
3E12: CD 38 47    call    snd_cmd_04_4738
3E15: DD 36 00 24 ld      (ix+$00),$24 ; '$'              ; use state as frame count (why?)
3E19: FD 36 00 20 ld      (iy+$00),$20 ; ' '              ; sprite code=explosion
3E1D: FD 36 01 0E ld      (iy+$01),$E                     ; sprite colour
3E21: 16 08       ld      d,8                           ; add to score & update hi
3E23: 1E 01       ld      e,1                           ; 100 pts
3E25: FF          rst     add_fn_to_q_0038
3E26: DD 7E 05    ld      a,(ix+$05)                        ; obj type
3E29: FE 03       cp      3                              ; rock or spinning_disc?
3E2B: D8          ret     C                               ; no,exit
3E2C: FD 36 01 05 ld      (iy+$01),5                       ; sprite colour
3E30: C9          ret
; ---------------------------------------------------------------------------

activate_obj_play_snd_3_3e31:                                        ; ...
3E31: DD 36 00 FF ld      (ix+$00),$FF                    ; state=active
3E35: CD 7D 47    call    snd_cmd_03_477d
3E38: C9          ret
; ---------------------------------------------------------------------------

animate_active_e300_obj_3e39:                                        ; ...
3E39: CD 2B 24    call    check_sprite_off_screen_242b         ; off-screen?
3E3C: DA 90 29    jp      C,deactivate_obj_2990               ; yes,go
3E3F: DD 7E 05    ld      a,(ix+$05)                        ; type
3E42: F7          rst    $30			  ; [jump_to_jump_table] [nb_entries=8]
; End of function update_e300_objects_3dc2

; ---------------------------------------------------------------------------
	.word animate_spinning_block_4018
	.word animate_yashichi_3f4b
	.word animate_eyeball_3f0a
	.word animate_rock_0_3ea9
	.word animate_rock_1_3ea3
	.word animate_rock_0_3ea9
	.word animate_rock_1_3ea3
	.word animate_spinning_disc_0_3e53
; ---------------------------------------------------------------------------

animate_spinning_disc_0_3e53:                                        ; ...
3E53: CD D2 3F    call    move_e300_obj_3fd2
3E56: DD 7E 01    ld      a,(ix+$01)                        ; obj counter/flag
3E59: A7          and     a
3E5A: CC 6C 3E    call    Z,init_spinning_disc_dy_dx_3e6c

; =============== S U B R O U T I N E =======================================


upd_spinning_disc_sprite_code_3e5d:                                  ; ...
3E5D: 3A 00 E0    ld      a,(vblank_tick_e000)
3E60: 0F          rrca
3E61: 0F          rrca
3E62: E6 07       and     7                              ; calc sprite code (0-7)
3E64: 21 8A 3E    ld      hl,spinning_disc_sprite_code_tbl_3e8a
3E67: E7          rst     content_hl_plus_a_0020               ; get entry addr
3E68: FD 77 00    ld      (iy+$00),a                        ; sprite code
3E6B: C9          ret
; End of function upd_spinning_disc_sprite_code_3e5d


; =============== S U B R O U T I N E =======================================


init_spinning_disc_dy_dx_3e6c:                                       ; ...
3E6C: DD 7E 08    ld      a,(ix+$08)                        ; obj dx msb
3E6F: A7          and     a                               ; moving fast?
3E70: C0          ret     NZ                              ; yes,exit
3E71: DD 36 06 00 ld      (ix+$06),0
3E75: DD 36 07 00 ld      (ix+$07),0                       ; obj dy = 0
3E79: DD 36 08 03 ld      (ix+$08),3
3E7D: DD 36 09 00 ld      (ix+$09),0                       ; obj dx = 3.0
3E81: DD 36 0C 00 ld      (ix+$0C),0
; End of function init_spinning_disc_dy_dx_3e6c

; START OF FUNCTION CHUNK FOR update_e300_objects_3dc2
3E85: DD 36 0D 00 ld      (ix+$0D),0                     ; zero obj dxx
3E89: C9          ret
; END OF FUNCTION CHUNK FOR update_e300_objects_3dc2
; ---------------------------------------------------------------------------
; 9th entry can't be used?!?
; ---------------------------------------------------------------------------

loc_3e93:                                                       ; ...
3E93: DD 34 05    inc     (ix+$05)                           ; obj type++
3E96: CD 95 6A    call    aim_directly_at_ship_6a95
3E99: DD 77 01    ld      (ix+$01),a                        ; obj counter/flag
3E9C: DD 36 0A 0D ld      (ix+$0a),13                    ; dy_dx entry index
3EA0: CD 98 28    call    lookup_dy_dx_store_2898

animate_rock_1_3ea3:                                                 ; ...
3EA3: CD 3B 24    call    move_object_self_243b
3EA6: 18 4B       jr      upd_rock_sprite_code_3ef3
; ---------------------------------------------------------------------------
3EA8: C9          ret
; ---------------------------------------------------------------------------

animate_rock_0_3ea9:                                                 ; ...
3EA9: 3A 60 E1    ld      a,(large_alien_obj_tbl_e160)        ; obj status
3EAC: 3C          inc     a                               ; active?
3EAD: 20 E4       jr      NZ,loc_3e93                    ; no,go
3EAF: 3A CD E0    ld      a,(related_to_big_alien_y_e0cd)
3EB2: DD 77 0B    ld      (ix+$0B),a
3EB5: 3A CE E0    ld      a,(related_to_big_alien_x_e0ce)
3EB8: DD 77 0C    ld      (ix+$0C),a
3EBB: DD 35 0D    dec     (ix+$0D)
3EBE: 28 D3       jr      Z,loc_3e93
3EC0: DD 7E 01    ld      a,(ix+$01)                        ; obj counter
3EC3: C6 FE       add     a,-2                          ; adjust
3EC5: DD 77 01    ld      (ix+$01),a                        ; update
3EC8: CD 98 28    call    lookup_dy_dx_store_2898
3ECB: DD 66 06    ld      h,(ix+$06)
3ECE: DD 6E 07    ld      l,(ix+$07)                        ; obj dy
3ED1: 29          add     hl,hl                          ; x2
3ED2: 29          add     hl,hl                          ; x4
3ED3: 29          add     hl,hl                          ; x8
3ED4: 29          add     hl,hl                          ; x16
3ED5: 29          add     hl,hl                          ; x32
3ED6: DD 56 0B    ld      d,(ix+$0B)
3ED9: 1E 00       ld      e,0                           ; obj ddy (msb.0)
3EDB: 19          add     hl,de
3EDC: FD 74 02    ld      (iy+$02),h                        ; update sprite y
3EDF: DD 66 08    ld      h,(ix+$08)
3EE2: DD 6E 09    ld      l,(ix+$09)                        ; obj dx
3EE5: 29          add     hl,hl                          ; x2
3EE6: 29          add     hl,hl                          ; x4
3EE7: 29          add     hl,hl                          ; x8
3EE8: 29          add     hl,hl                          ; x16
3EE9: 29          add     hl,hl                          ; x32
3EEA: DD 56 0C    ld      d,(ix+$0C)
3EED: 1E 00       ld      e,0                           ; obj ddx (msb.0)
3EEF: 19          add     hl,de                          ; dx+ddx
3EF0: FD 74 03    ld      (iy+$03),h                        ; update sprite x

upd_rock_sprite_code_3ef3:                                           ; ...
3EF3: 3A 00 E0    ld      a,(vblank_tick_e000)
3EF6: 0F          rrca
3EF7: 0F          rrca
3EF8: E6 07       and     7                              ; calc sprite code (index)
3EFA: 21 02 3F    ld      hl,rock_sprite_code_tbl_0_3f02
3EFD: E7          rst     content_hl_plus_a_0020               ; get code
3EFE: FD 77 00    ld      (iy+$00),a                        ; sprite code
3F01: C9          ret
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------

animate_eyeball_3f0a:                                                ; ...
3F0A: CD D2 3F    call    move_e300_obj_3fd2
3F0D: DD 7E 01    ld      a,(ix+$01)                        ; counter
3F10: A7          and     a
3F11: CC 2D 3F    call    Z,zero_obj_dx_ddx_3f2d              ; time to ?
3F14: FD 7E 00    ld      a,(iy+$00)                        ; get sprite code
3F17: FE D8       cp      $D8 ; '�'                     ; 1st code?
3F19: 28 08       jr      Z,loc_3f23                     ; yes,go
3F1B: FE CF       cp      $CF ; '�'                     ; last code?
3F1D: 28 09       jr      Z,loc_3f28                     ; yes,go
3F1F: FD 34 00    inc     (iy+$00)                           ; next sprite code
3F22: C9          ret
; ---------------------------------------------------------------------------

loc_3f23:                                                       ; ...
3F23: FD 36 00 CC ld      (iy+$00),$CC ; '�'              ; 2nd sprite code
3F27: C9          ret
; ---------------------------------------------------------------------------

loc_3f28:                                                       ; ...
3F28: FD 36 00 D8 ld      (iy+$00),$D8 ; '�'              ; 1st sprite code
3F2C: C9          ret

; =============== S U B R O U T I N E =======================================


zero_obj_dx_ddx_3f2d:                                                ; ...
3F2D: DD 7E 08    ld      a,(ix+$08)                        ; obj dx msb
3F30: A7          and     a                               ; moving fast?
3F31: C0          ret     NZ                              ; yes,exit
3F32: DD 36 08 00 ld      (ix+$08),0
3F36: DD 36 09 00 ld      (ix+$09),0                       ; obj dx=0
3F3A: DD 36 0C 00 ld      (ix+$0C),0
3F3E: DD 36 0D 00 ld      (ix+$0D),0                     ; zero obj ddx
3F42: C9          ret
; End of function zero_obj_dx_ddx_3f2d

; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; yashichi (red circle with ninja star)

animate_yashichi_3f4b:                                               ; ...
3F4B: DD 7E 01    ld      a,(ix+$01)                        ; obj counter (flag)
3F4E: A7          and     a                               ; moving fast?
3F4F: CC 73 3F    call    Z,calc_yashichi_dy_dx_3f73          ; no,go
3F52: CD D2 3F    call    move_e300_obj_3fd2
3F55: DD 7E 01    ld      a,(ix+$01)                        ; obj counter (flag)
3F58: A7          and     a                               ; moving fast?
3F59: 28 0D       jr      Z,yashichi_spin_slow_3f68           ; no,go
3F5B: 3A 00 E0    ld      a,(vblank_tick_e000)                ; spin fast

loc_3f5e:                                                       ; ...
3F5E: E6 03       and     3                              ; calc sprite code
3F60: 21 6F 3F    ld      hl,yashichi_sprite_code_tbl_3f6f
3F63: E7          rst     content_hl_plus_a_0020               ; get entry
3F64: FD 77 00    ld      (iy+$00),a                        ; sprite code
3F67: C9          ret
; ---------------------------------------------------------------------------

yashichi_spin_slow_3f68:                                             ; ...
3F68: 3A 00 E0    ld      a,(vblank_tick_e000)
3F6B: 0F          rrca
3F6C: 0F          rrca                                    ; calc sprite code
3F6D: 18 EF       jr      loc_3f5e
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================


calc_yashichi_dy_dx_3f73:                                            ; ...
3F73: DD 7E 08    ld      a,(ix+$08)                        ; obj dx msb
3F76: A7          and     a                               ; moving fast?
3F77: C0          ret     NZ                              ; yes,exit
3F78: DD 34 01    inc     (ix+$01)                           ; obj counter/flag
3F7B: 3A 02 EF    ld      a,(spriteram_shadow_ef00+2)         ; s0.y
3F7E: FD 96 02    sub     (iy+$02)                           ; sub obj.y
3F81: 67          ld      h,a                            ; diff in msb
3F82: 2E 00       ld      l,0
3F84: CB 2C       sra     h
3F86: CB 1D       rr      l                               ; /2
3F88: CB 2C       sra     h
3F8A: CB 1D       rr      l                               ; /4
3F8C: CB 2C       sra     h
3F8E: CB 1D       rr      l                               ; /8
3F90: CB 2C       sra     h
3F92: CB 1D       rr      l                               ; /16
3F94: CB 2C       sra     h
3F96: CB 1D       rr      l                               ; /32
3F98: DD 74 06    ld      (ix+$06),h
3F9B: DD 75 07    ld      (ix+$07),l                        ; init obj dy
3F9E: DD 36 0A 00 ld      (ix+$0a),0
3FA2: DD 36 0B 00 ld      (ix+$0B),0                     ; zero obj ddy
3FA6: 3A 03 EF    ld      a,(spriteram_shadow_ef00+3)         ; s0.x
3FA9: FD 96 03    sub     (iy+$03)                           ; sub obj x
3FAC: 67          ld      h,a
3FAD: 2E 00       ld      l,0                           ; diff in msb
3FAF: CB 2C       sra     h
3FB1: CB 1D       rr      l                               ; /2
3FB3: CB 2C       sra     h
3FB5: CB 1D       rr      l                               ; /4
3FB7: CB 2C       sra     h
3FB9: CB 1D       rr      l                               ; /8
3FBB: CB 2C       sra     h
3FBD: CB 1D       rr      l                               ; /16
3FBF: CB 2C       sra     h
3FC1: CB 1D       rr      l                               ; /32
3FC3: DD 74 08    ld      (ix+$08),h
3FC6: DD 75 09    ld      (ix+$09),l                        ; init dx
3FC9: DD 36 0C 00 ld      (ix+$0C),0
3FCD: DD 36 0D 00 ld      (ix+$0D),0                     ; zero obj ddx
3FD1: C9          ret
; End of function calc_yashichi_dy_dx_3f73


; =============== S U B R O U T I N E =======================================


move_e300_obj_3fd2:                                                  ; ...
3FD2: DD 66 06    ld      h,(ix+$06)
3FD5: DD 6E 07    ld      l,(ix+$07)                        ; obj dy
3FD8: DD 56 0A    ld      d,(ix+$0a)
3FDB: DD 5E 0B    ld      e,(ix+$0B)                      ; obj ddy
3FDE: 19          add     hl,de
3FDF: DD 74 06    ld      (ix+$06),h
3FE2: DD 75 07    ld      (ix+$07),l                        ; update obj dy
3FE5: FD 56 02    ld      d,(iy+$02)                        ; sprite y
3FE8: DD 5E 03    ld      e,(ix+$03)                        ; sprite y lsb
3FEB: 19          add     hl,de
3FEC: EB          ex      de,hl
3FED: 2A 09 E1    ld      hl,(airborne_dy_e109)
3FF0: 19          add     hl,de                          ; move w/bg
3FF1: FD 74 02    ld      (iy+$02),h                        ; update sprite y
3FF4: DD 75 03    ld      (ix+$03),l                        ; update obj y lsb
3FF7: DD 66 08    ld      h,(ix+$08)
3FFA: DD 6E 09    ld      l,(ix+$09)                        ; obj dx
3FFD: DD 56 0C    ld      d,(ix+$0C)
4000: DD 5E 0D    ld      e,(ix+$0D)                      ; obj ddx
4003: 19          add     hl,de
4004: DD 74 08    ld      (ix+$08),h
4007: DD 75 09    ld      (ix+$09),l                        ; update obj dx
400A: FD 56 03    ld      d,(iy+$03)                        ; sprite x
400D: DD 5E 04    ld      e,(ix+$04)                        ; obj x lsb
4010: 19          add     hl,de
4011: FD 74 03    ld      (iy+$03),h                        ; update sprite x
4014: DD 75 04    ld      (ix+$04),l                        ; update obj x lsb
4017: C9          ret
; End of function move_e300_obj_3fd2

; ---------------------------------------------------------------------------
; spinning (Z and Y axis) black block

animate_spinning_block_4018:                                         ; ...
4018: DD 7E 01    ld      a,(ix+$01)                        ; obj counter
401B: E6 03       and     3
401D: F7          rst    $30			  ; [jump_to_jump_table] [nb_entries=3]
; ---------------------------------------------------------------------------
	.word anim_block_z_spin_4024
	.word anim_block_y_spin_4053
	.word move_object_self_243b
; ---------------------------------------------------------------------------

anim_block_z_spin_4024:                                              ; ...
4024: CD 3B 24    call    move_object_self_243b
4027: 3A 00 E0    ld      a,(vblank_tick_e000)
402A: 47          ld      b,a
402B: 0F          rrca
402C: E6 03       and     3
402E: C6 D4       add     a,$D4 ;                   ; calc sprite code
4030: FD 77 00    ld      (iy+$00),a                        ; sprite code
4033: DD 35 0D    dec     (ix+$0D)                         ; obj ddx lsb
4036: C0          ret     NZ
4037: DD 34 01    inc     (ix+$01)
403A: DD 66 06    ld      h,(ix+$06)
403D: DD 6E 07    ld      l,(ix+$07)                        ; obj dy
4040: CB 2C       sra     h
4042: CB 1D       rr      l                               ; /2
4044: CB 2C       sra     h
4046: CB 1D       rr      l                               ; /4
4048: DD 74 06    ld      (ix+$06),h
404B: DD 75 07    ld      (ix+$07),l                        ; update obj dy
404E: DD 36 02 00 ld      (ix+$02),0                       ; init timer_e025
4052: C9          ret
; ---------------------------------------------------------------------------

anim_block_y_spin_4053:                                              ; ...
4053: CD 3B 24    call    move_object_self_243b
4056: 3A 00 E0    ld      a,(vblank_tick_e000)
4059: E6 03       and     3                              ; time to spin?
405B: C0          ret     NZ                              ; no,exit
405C: DD 7E 02    ld      a,(ix+$02)                        ; timer_e025
405F: DD 34 02    inc     (ix+$02)
4062: FE 05       cp      5                              ; time to ?
4064: 30 08       jr      NC,loc_406e                    ; yes,go
4066: 21 83 40    ld      hl,spinning_block_sprite_code_tbl_4083
4069: E7          rst     content_hl_plus_a_0020               ; get code
406A: FD 77 00    ld      (iy+$00),a                        ; set sprite code
406D: C9          ret
; ---------------------------------------------------------------------------

loc_406e:                                                       ; ...
406E: DD 34 01    inc     (ix+$01)
4071: DD 36 06 00 ld      (ix+$06),0
4075: DD 36 07 00 ld      (ix+$07),0                       ; zero obj dy
4079: 21 48 FF    ld      hl,-184
407C: DD 74 08    ld      (ix+$08),h
407F: DD 75 09    ld      (ix+$09),l                        ; update obj dx
4082: C9          ret
; ---------------------------------------------------------------------------
; last byte not used!

; =============== S U B R O U T I N E =======================================


init_bg_prerender_and_cls_4089:                                      ; ...
4089: 3E 20       ld      a,$20 ; ' '                  ; 32 lines to render
408B: 32 48 E0    ld      (bg_lines_to_render_e048),a
408E: 21 00 D8    ld      hl,bgvideoram_code_d800
4091: 22 49 E0    ld      (bg_prerender_ptr_e049),hl

clear_bg_4094:                                                       ; ...
4094: 21 50 E0    ld      hl,bg_prerender_buffer_e050
4097: 06 20       ld      b,$20 ; ' '                  ; 32 columns

loc_4099:                                                       ; ...
4099: 36 FF       ld      (hl),$FF                     ; blank tile
409B: 23          inc     hl
409C: 10 FB       djnz    loc_4099
409E: 06 20       ld      b,$20 ; ' '                  ; 32 rows

loc_40a0:                                                       ; ...
40A0: 36 80       ld      (hl),$80 ; '�'               ; code MSb & colour
40A2: 23          inc     hl
40A3: 10 FB       djnz    loc_40a0
40A5: C9          ret
; End of function init_bg_prerender_and_cls_4089


; =============== S U B R O U T I N E =======================================


inc_bg_prerender_buffer_40a6:                                        ; ...
40A6: 2A 49 E0    ld      hl,(bg_prerender_ptr_e049)
40A9: 3E 20       ld      a,$20 ; ' '
40AB: DF          rst     hl_plus_equals_a_0018                ; next column
40AC: 7C          ld      a,h
40AD: E6 DB       and     $DB ; '�'                     ; handle wrap
40AF: 67          ld      h,a
40B0: 22 49 E0    ld      (bg_prerender_ptr_e049),hl          ; update
40B3: 3A 48 E0    ld      a,(bg_lines_to_render_e048)
40B6: A7          and     a
40B7: C9          ret
; End of function inc_bg_prerender_buffer_40a6


; =============== S U B R O U T I N E =======================================


clear_bg_via_renderer_40b8:                                          ; ...
40B8: DD 21 A0 E1 ld      ix,curr_player_map_data_e1a0
40BC: DD 66 0A    ld      h,(ix+$0a)
40BF: DD 6E 0B    ld      l,(ix+$0b)
40C2: 22 49 E0    ld      (bg_prerender_ptr_e049),hl
40C5: 3E 20       ld      a,32                          ; 32 lines to render
40C7: 32 48 E0    ld      (bg_lines_to_render_e048),a
40CA: 18 C8       jr      clear_bg_4094
; End of function clear_bg_via_renderer_40b8


; =============== S U B R O U T I N E =======================================


show_char_test_screen_40cc:                                          ; ...
40CC: 21 BB D0    ld      hl,fgvideoram_code_d000+0xBB
40CF: 0E 08       ld      c,8
40D1: AF          xor     a

loc_40d2:                                                       ; ...
40D2: 06 08       ld      b,8

loc_40d4:                                                       ; ...
40D4: 11 20 00    ld      de,$20 ; ' '
40D7: 77          ld      (hl),a
40D8: 2B          dec     hl
40D9: C6 02       add     a,2
40DB: 77          ld      (hl),a
40DC: 19          add     hl,de
40DD: 3C          inc     a
40DE: 77          ld      (hl),a
40DF: 23          inc     hl
40E0: D6 02       sub     2
40E2: 77          ld      (hl),a
40E3: C6 03       add     a,3
40E5: 11 40 00    ld      de,$40 ; '@'
40E8: 19          add     hl,de
40E9: 10 E9       djnz    loc_40d4
40EB: 0D          dec     c
40EC: 28 07       jr      Z,loc_40f5
40EE: 11 FD FC    ld      de,$FCFD
40F1: 19          add     hl,de
40F2: C3 D2 40    jp      loc_40d2
; ---------------------------------------------------------------------------

loc_40f5:                                                       ; ...
40F5: 21 21 E0    ld      hl,tmp_e021
40F8: 36 00       ld      (hl),0
; End of function show_char_test_screen_40cc

; START OF FUNCTION CHUNK FOR sub_4110

print_color_e021_40fa:                                               ; ...
40FA: 21 06 41    ld      hl,strcolor_4106
40FD: CD 8F 41    call    print_string_418f
4100: 3A 21 E0    ld      a,(tmp_e021)
4103: C3 BF 41    jp      print_hex_byte_41bf
; END OF FUNCTION CHUNK FOR sub_4110
; ---------------------------------------------------------------------------
	.word fgvideoram_code_d000+0x9D                ; ...
;acolor_4109:                 .ascii 'COLOR '

; =============== S U B R O U T I N E =======================================


sub_4110:                                                       ; ...

; FUNCTION CHUNK AT ROM:40FA SIZE 0000000C BYTES
; FUNCTION CHUNK AT ROM:4166 SIZE 0000001A BYTES

4110: 21 20 E0    ld      hl,tmp_e020
4113: 36 00       ld      (hl),0
4115: CD 23 41    call    handle_up_down_4123
4118: CD 4C 41    call    debounce_b1_414c
411B: 3A 20 E0    ld      a,(tmp_e020)
411E: A7          and     a                               ; anything pressed?
411F: C8          ret     Z                               ; no,return
4120: C3 66 41    jp      fg_set_colour_4166
; End of function sub_4110


; =============== S U B R O U T I N E =======================================


handle_up_down_4123:                                                 ; ...
4123: 06 01       ld      b,1                           ; flag up
4125: 21 0B E0    ld      hl,curr_player_up_e00b
4128: 7E          ld      a,(hl)
4129: E6 07       and     7                              ; last 3 read
412B: FE 03       cp      3                              ; 011?
412D: 28 0B       jr      Z,loc_413a                     ; yes,go
412F: 21 0A E0    ld      hl,curr_player_down_e00a
4132: 7E          ld      a,(hl)
4133: E6 07       and     7                              ; last 3 read
4135: FE 03       cp      3                              ; 011?
4137: C0          ret     NZ                              ; no,return
4138: 06 FF       ld      b,$FF                        ; flag down

loc_413a:                                                       ; ...
413A: 3A 21 E0    ld      a,(tmp_e021)
413D: 5F          ld      e,a
413E: E6 C0       and     $C0 ; '�'
4140: 57          ld      d,a
4141: 7B          ld      a,e
4142: 80          add     a,b                            ; adjust for up/down
4143: E6 3F       and     $3F ; '?'
4145: 82          add     a,d
4146: 32 21 E0    ld      (tmp_e021),a
4149: C3 60 41    jp      loc_4160
; End of function handle_up_down_4123


; =============== S U B R O U T I N E =======================================


debounce_b1_414c:                                                    ; ...
414C: 21 0C E0    ld      hl,curr_player_b1_e00c
414F: 7E          ld      a,(hl)
4150: E6 07       and     7                              ; last 3 reads
4152: FE 03       cp      3                              ; 011?
4154: C0          ret     NZ                              ; no,return
4155: 3A 21 E0    ld      a,(tmp_e021)
4158: C6 80       add     a,$80 ; '�'
415A: 32 21 E0    ld      (tmp_e021),a
415D: CD 5D 47    call    play_bullet_snd_475d

loc_4160:                                                       ; ...
4160: 3E FF       ld      a,$FF
4162: 32 20 E0    ld      (tmp_e020),a
4165: C9          ret
; End of function debounce_b1_414c

; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR sub_4110

fg_set_colour_4166:                                                  ; ...
4166: 3A 21 E0    ld      a,(tmp_e021)                   ; colour
4169: 21 A5 D4    ld      hl,fgvideoram_color_d400+0xA5
416C: 0E 18       ld      c,24                          ; rows to fill

loc_416e:                                                       ; ...
416E: 06 18       ld      b,24                          ; columns to fill
4170: 11 20 00    ld      de,$20 ; ' '                 ; columns offset
4173: E5          push    hl

loc_4174:                                                       ; ...
4174: 77          ld      (hl),a
4175: 19          add     hl,de                          ; next column
4176: 10 FC       djnz    loc_4174
4178: E1          pop     hl
4179: 23          inc     hl                              ; next row
417A: 0D          dec     c
417B: 20 F1       jr      NZ,loc_416e
417D: C3 FA 40    jp      print_color_e021_40fa
; END OF FUNCTION CHUNK FOR sub_4110
; ---------------------------------------------------------------------------
4180: D9          exx
4181: 21 02 E0    ld      hl,p1_e002
4184: 3A 82 EF    ld      a,(flipscreen_shadow_ef82)
4187: CB 7F       bit     7,a                            ; flipped?
4189: 28 01       jr      Z,loc_418c                     ; no,skip
418B: 23          inc     hl

loc_418c:                                                       ; ...
418C: 7E          ld      a,(hl)
418D: D9          exx
418E: C9          ret

; =============== S U B R O U T I N E =======================================


print_string_418f:                                                   ; ...
418F: 5E          ld      e,(hl)
4190: 23          inc     hl
4191: 56          ld      d,(hl)
4192: 23          inc     hl                              ; DE=videoram address
4193: 4E          ld      c,(hl)                         ; colour
4194: 23          inc     hl
4195: EB          ex      de,hl

loc_4196:                                                       ; ...
4196: 1A          ld      a,(de)                         ; get character
4197: FE 40       cp      $40 ; '@'                     ; end of string?
4199: C8          ret     Z                               ; yes,return
419A: 77          ld      (hl),a                         ; code=character [unchecked_address]
419B: CB D4       set     2,h                            ; ptr colour
419D: 71          ld      (hl),c                         ; set colour [video_address]
419E: CB 94       res     2,h                            ; ptr code
41A0: 3E 20       ld      a,$20 ; ' '
41A2: DF          rst     hl_plus_equals_a_0018                ; next column
41A3: 13          inc     de                              ; next character
41A4: 18 F0       jr      loc_4196                        ; loop
; End of function print_string_418f


; =============== S U B R O U T I N E =======================================


wipe_string_41a6:                                                    ; ...
41A6: 5E          ld      e,(hl)
41A7: 23          inc     hl
41A8: 56          ld      d,(hl)
41A9: 23          inc     hl                              ; DE=videoram address
41AA: 4E          ld      c,(hl)
41AB: 23          inc     hl
41AC: EB          ex      de,hl

loc_41ad:                                                       ; ...
41AD: 1A          ld      a,(de)                         ; get character
41AE: FE 40       cp      $40 ; '@'                     ; end of string?
41B0: C8          ret     Z                               ; yes,return
41B1: 36 20       ld      (hl),$20 ; ' '               ; code=blank  [unchecked_address]
41B3: CB D4       set     2,h                            ; ptr colour
41B5: 36 00       ld      (hl),0                        ; colour=0   [video_address]
41B7: CB 94       res     2,h                            ; ptr code
41B9: 3E 20       ld      a,$20 ; ' '
41BB: DF          rst     hl_plus_equals_a_0018                ; next column
41BC: 13          inc     de                              ; next char
41BD: 18 EE       jr      loc_41ad                        ; loop
; End of function wipe_string_41a6


; =============== S U B R O U T I N E =======================================


print_hex_byte_41bf:                                                 ; ...
41BF: 47          ld      b,a
41C0: 0F          rrca
41C1: 0F          rrca
41C2: 0F          rrca
41C3: 0F          rrca
41C4: E6 0F       and     $F                            ; high nibble to low byte
41C6: CD CC 41    call    print_hex_digit_41cc
41C9: 78          ld      a,b                            ; low nibble
41CA: E6 0F       and     $F
; End of function print_hex_byte_41bf


; =============== S U B R O U T I N E =======================================


print_hex_digit_41cc:                                                ; ...
41CC: EB          ex      de,hl
41CD: 21 DC 41    ld      hl,ascii_hex_tbl_41dc
41D0: E7          rst     content_hl_plus_a_0020               ; get hex char
41D1: EB          ex      de,hl
41D2: 77          ld      (hl),a                         ; set code   [unchecked_address]
41D3: CB D4       set     2,h                            ; ptr colour
41D5: 71          ld      (hl),c                         ; set colour [video_address]
41D6: CB 94       res     2,h                            ; ptr code
41D8: 3E 20       ld      a,$20 ; ' '
41DA: DF          rst     hl_plus_equals_a_0018                ; next column
41DB: C9          ret
; End of function print_hex_digit_41cc

; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------

print_p1_score_0_41ec:                                               ; ...
41EC: 3E 09       ld      a,9                           ; colour
41EE: 4F          ld      c,a                            ; save
41EF: 21 1E D1    ld      hl,fgvideoram_code_d000+0x11E
41F2: 36 30       ld      (hl),$30 ; '0'			[unchecked_address]
41F4: CB D4       set     2,h                            ; ptr colour
41F6: 71          ld      (hl),c                         ; colour  [video_address]
41F7: 21 5E D0    ld      hl,fgvideoram_code_d000+0x5E
41FA: 11 41 EE    ld      de,p1_score_ee41
41FD: C3 97 43    jp      print_score_digits_4397
; ---------------------------------------------------------------------------
4200: C9          ret
; ---------------------------------------------------------------------------

print_p2_score_0_4201:                                               ; ...
4201: 3E 09       ld      a,9
4203: 4F          ld      c,a
4204: 21 BE D3    ld      hl,fgvideoram_code_d000+0x3BE
4207: 36 30       ld      (hl),$30 ; '0'    [unchecked_address]
4209: CB D4       set     2,h                            ; ptr colour
420B: 71          ld      (hl),c                         ; colour  [video_address]
420C: 21 FE D2    ld      hl,fgvideoram_code_d000+0x2FE
420F: 11 44 EE    ld      de,p2_score_ee44
4212: C3 97 43    jp      print_score_digits_4397

; =============== S U B R O U T I N E =======================================


print_hi_score_0_4215:                                               ; ...
4215: 3E 01       ld      a,1                           ; colour
4217: 4F          ld      c,a                            ; save
4218: 21 7E D2    ld      hl,fgvideoram_code_d000+0x27E
421B: 36 30       ld      (hl),$30 ; '0'               ; '0'   [unchecked_address]
421D: CB D4       set     2,h                            ; ptr to colour
421F: 71          ld      (hl),c     ; [video_address]
4220: CB 94       res     2,h                            ; ptr to code
4222: 21 BE D1    ld      hl,fgvideoram_code_d000+0x1BE
4225: 11 47 EE    ld      de,hi_score_ee47
4228: C3 97 43    jp      print_score_digits_4397
; End of function print_hi_score_0_4215

; ---------------------------------------------------------------------------
; ** UNUSED code???
422B: 47          ld      b,a
422C: 0F          rrca
422D: 0F          rrca
422E: 0F          rrca
422F: 0F          rrca
4230: E6 0F       and     $F                            ; high->low nibble
4232: CA 3A 42    jp      Z,loc_423a                     ; skip if 0
4235: CD CC 41    call    print_hex_digit_41cc
4238: 18 0F       jr      loc_4249
; ---------------------------------------------------------------------------

loc_423a:                                                       ; ...
423A: 08          ex      af,af'
423B: 7E          ld      a,(hl)
423C: FE 20       cp      $20 ; ' '
423E: 28 06       jr      Z,loc_4246
4240: 08          ex      af,af'
4241: CD CC 41    call    print_hex_digit_41cc
4244: 18 03       jr      loc_4249
; ---------------------------------------------------------------------------

loc_4246:                                                       ; ...
4246: 3E 20       ld      a,$20 ; ' '
4248: DF          rst     hl_plus_equals_a_0018

loc_4249:                                                       ; ...
4249: 78          ld      a,b
424A: E6 0F       and     $F                            ; low nibble
424C: C2 CC 41    jp      NZ,print_hex_digit_41cc             ; print if non-zero
424F: 7E          ld      a,(hl)
4250: FE 20       cp      $20 ; ' '
4252: C8          ret     Z
4253: C3 CC 41    jp      print_hex_digit_41cc

; =============== S U B R O U T I N E =======================================


init_scroll_cnt_4256:                                                ; ...
4256: 3E 1C       ld      a,28
4258: 32 20 E0    ld      (tmp_e020),a
425B: C9          ret
; End of function init_scroll_cnt_4256


; =============== S U B R O U T I N E =======================================


scroll_left_1_col_425c:                                              ; ...
425C: 21 22 D0    ld      hl,fgvideoram_code_d000+0x22
425F: 22 26 E0    ld      (tmp_scroll_addr_e026),hl
4262: 3E 1C       ld      a,28
4264: 32 28 E0    ld      (tmp_scroll_cols_e028),a

loc_4267:                                                       ; ...
4267: 2A 26 E0    ld      hl,(tmp_scroll_addr_e026)
426A: 54          ld      d,h
426B: 5D          ld      e,l
426C: 3E 20       ld      a,$20 ; ' '
426E: DF          rst     hl_plus_equals_a_0018                ; next column
426F: 01 12 00    ld      bc,18                         ; bytes (rows) to copy
4272: ED B0       ldir			; [video_address]
4274: 2A 26 E0    ld      hl,(tmp_scroll_addr_e026)
4277: 54          ld      d,h
4278: 5D          ld      e,l
4279: 3E 20       ld      a,$20 ; ' '
427B: DF          rst     hl_plus_equals_a_0018                ; next column
427C: 22 26 E0    ld      (tmp_scroll_addr_e026),hl           ; update tmp pointer
427F: CB D4       set     2,h                            ; colour RAM (src)
4281: CB D2       set     2,d                            ; colour RAM (dst)
4283: 01 12 00    ld      bc,18                         ; bytes (rows) to copy
4286: ED B0       ldir			; [video_address]
4288: 3A 28 E0    ld      a,(tmp_scroll_cols_e028)
428B: 3D          dec     a
428C: 32 28 E0    ld      (tmp_scroll_cols_e028),a            ; update
428F: 20 D6       jr      NZ,loc_4267
4291: 3A 20 E0    ld      a,(tmp_e020)
4294: 3D          dec     a
4295: 32 20 E0    ld      (tmp_e020),a
4298: C9          ret
; End of function scroll_left_1_col_425c


; =============== S U B R O U T I N E =======================================


clear_pressed_flags_4299:                                            ; ...
4299: AF          xor     a
429A: 32 2A E0    ld      (up_down_pressed_e02a),a
429D: 32 29 E0    ld      (left_right_b1_pressed_e029),a
42A0: C9          ret
; End of function clear_pressed_flags_4299


; =============== S U B R O U T I N E =======================================


show_sprite_test_screen_42a1:                                        ; ...
42A1: 11 04 00    ld      de,4                          ; bytes per sprite
42A4: D9          exx
42A5: FD 21 00 EF ld      iy,spriteram_shadow_ef00
42A9: 3A 2A E0    ld      a,(up_down_pressed_e02a)
42AC: 57          ld      d,a                            ; sprite.code
42AD: 3A 29 E0    ld      a,(left_right_b1_pressed_e029)
42B0: 5F          ld      e,a                            ; sprite.colour
42B1: 26 20       ld      h,32                          ; sprite.y
42B3: 2E 9E       ld      l,158                         ; sprite.x
42B5: 0E 03       ld      c,3                           ; 3x8 sprites

loc_42b7:                                                       ; ...
42B7: 06 08       ld      b,8                           ; 8 sprites to init

loc_42b9:                                                       ; ...
42B9: FD 74 02    ld      (iy+$02),h                        ; sprite.y
42BC: FD 75 03    ld      (iy+$03),l                        ; sprite.x
42BF: FD 73 01    ld      (iy+$01),e                        ; sprite.colour
42C2: FD 72 00    ld      (iy+$00),d                        ; sprite.code
42C5: D9          exx
42C6: FD 19       add     iy,de                          ; next sprite
42C8: D9          exx
42C9: 14          inc     d
42CA: 7C          ld      a,h
42CB: C6 18       add     a,24                          ; sprite.y += 24
42CD: 67          ld      h,a
42CE: 10 E9       djnz    loc_42b9                        ; loop
42D0: 7C          ld      a,h
42D1: C6 40       add     a,64                          ; sprite.y += 64
42D3: 67          ld      h,a
42D4: 7D          ld      a,l
42D5: C6 E0       add     a,$E0 ; '�'                  ; sprite.x -= 32
42D7: 6F          ld      l,a
42D8: 0D          dec     c                               ; next group of 8 sprites
42D9: 20 DC       jr      NZ,loc_42b7                    ; loop
42DB: 21 06 41    ld      hl,strcolor_4106
42DE: CD 8F 41    call    print_string_418f
42E1: 3A 29 E0    ld      a,(left_right_b1_pressed_e029)
42E4: CD BF 41    call    print_hex_byte_41bf
42E7: 21 96 D0    ld      hl,fgvideoram_code_d000+0x96
42EA: 3A 2A E0    ld      a,(up_down_pressed_e02a)
42ED: 08          ex      af,af'
42EE: 0E 03       ld      c,3

loc_42f0:                                                       ; ...
42F0: 06 08       ld      b,8
42F2: E5          push    hl

loc_42f3:                                                       ; ...
42F3: C5          push    bc
42F4: 0E 08       ld      c,8
42F6: 08          ex      af,af'
42F7: 57          ld      d,a
42F8: 3C          inc     a
42F9: 08          ex      af,af'
42FA: 7A          ld      a,d
42FB: CD BF 41    call    print_hex_byte_41bf
42FE: 3E 20       ld      a,$20 ; ' '
4300: DF          rst     hl_plus_equals_a_0018                ; next column
4301: C1          pop     bc
4302: 10 EF       djnz    loc_42f3
4304: E1          pop     hl
4305: 7D          ld      a,l
4306: C6 FC       add     a,$FC ; '�'
4308: 6F          ld      l,a
4309: 0D          dec     c
430A: 20 E4       jr      NZ,loc_42f0
430C: C9          ret
; End of function show_sprite_test_screen_42a1


; =============== S U B R O U T I N E =======================================


debounce_inputs_430d:                                                ; ...
430D: AF          xor     a
430E: 32 20 E0    ld      (tmp_e020),a
4311: 3A 0C E0    ld      a,(curr_player_b1_e00c)
4314: E6 07       and     7                              ; last 3 reads
4316: FE 03       cp      3                              ; 011?
4318: CC 4C 43    call    Z,handle_debounced_b1_434c          ; yes,go
431B: 3A 0B E0    ld      a,(curr_player_up_e00b)
431E: E6 07       and     7                              ; last 3 reads
4320: FE 03       cp      3                              ; 011?
4322: CC 59 43    call    Z,handle_debounced_up_4359          ; yes,go
4325: 3A 0A E0    ld      a,(curr_player_down_e00a)
4328: E6 07       and     7                              ; last 3 reads
432A: FE 03       cp      3                              ; 011?
432C: CC 67 43    call    Z,handle_debounced_down_4367        ; yes,go
432F: 3A 09 E0    ld      a,(curr_player_left_e009)
4332: E6 07       and     7                              ; last 3 reads
4334: FE 03       cp      3                              ; 011?
4336: CC 75 43    call    Z,handle_debounced_left_4375        ; yes,go
4339: 3A 08 E0    ld      a,(curr_player_right_e008)
433C: E6 07       and     7                              ; last 3 reads
433E: FE 03       cp      3                              ; 011?
4340: CC 83 43    call    Z,handle_debounced_right_4383       ; yes,go
4343: 3A 20 E0    ld      a,(tmp_e020)
4346: A7          and     a                               ; button (just) pressed?
4347: C8          ret     Z                               ; no,return
4348: CD A1 42    call    show_sprite_test_screen_42a1
434B: C9          ret
; End of function debounce_inputs_430d


; =============== S U B R O U T I N E =======================================


handle_debounced_b1_434c:                                            ; ...
434C: 3A 29 E0    ld      a,(left_right_b1_pressed_e029)
434F: 3C          inc     a
4350: 32 29 E0    ld      (left_right_b1_pressed_e029),a
4353: CD 13 47    call    play_pickup_snd_4713
4356: C3 91 43    jp      flag_button_pressed_4391
; End of function handle_debounced_b1_434c


; =============== S U B R O U T I N E =======================================


handle_debounced_up_4359:                                            ; ...
4359: 3A 2A E0    ld      a,(up_down_pressed_e02a)
435C: C6 08       add     a,8
435E: 32 2A E0    ld      (up_down_pressed_e02a),a
4361: CD 28 47    call    snd_cmd_01_4728
4364: C3 91 43    jp      flag_button_pressed_4391
; End of function handle_debounced_up_4359


; =============== S U B R O U T I N E =======================================


handle_debounced_down_4367:                                          ; ...
4367: 3A 2A E0    ld      a,(up_down_pressed_e02a)
436A: D6 08       sub     8
436C: 32 2A E0    ld      (up_down_pressed_e02a),a
436F: CD 38 47    call    snd_cmd_04_4738
4372: C3 91 43    jp      flag_button_pressed_4391
; End of function handle_debounced_down_4367


; =============== S U B R O U T I N E =======================================


handle_debounced_left_4375:                                          ; ...
4375: 3A 29 E0    ld      a,(left_right_b1_pressed_e029)
4378: C6 10       add     a,16
437A: 32 29 E0    ld      (left_right_b1_pressed_e029),a
437D: CD 38 47    call    snd_cmd_04_4738
4380: C3 91 43    jp      flag_button_pressed_4391
; End of function handle_debounced_left_4375


; =============== S U B R O U T I N E =======================================


handle_debounced_right_4383:                                         ; ...
4383: 3A 29 E0    ld      a,(left_right_b1_pressed_e029)
4386: D6 10       sub     16
4388: 32 29 E0    ld      (left_right_b1_pressed_e029),a
438B: CD 5D 47    call    play_bullet_snd_475d
438E: C3 91 43    jp      flag_button_pressed_4391
; ---------------------------------------------------------------------------

flag_button_pressed_4391:                                            ; ...
4391: 3E 01       ld      a,1
4393: 32 20 E0    ld      (tmp_e020),a
4396: C9          ret
; End of function handle_debounced_right_4383

; DE=score (BCD) (no trailing '0')

; =============== S U B R O U T I N E =======================================


print_score_digits_4397:                                             ; ...
4397: AF          xor     a
4398: 32 2B E0    ld      (non_zero_digit_e02b),a
439B: 3E 06       ld      a,6                           ; 6 digits to print
439D: 32 2C E0    ld      (digits_to_print_e02c),a            ; save

loc_43a0:                                                       ; ...
43A0: 1A          ld      a,(de)
43A1: 1C          inc     e
43A2: 47          ld      b,a                            ; save
43A3: 0F          rrca
43A4: 0F          rrca
43A5: 0F          rrca
43A6: 0F          rrca                                    ; shift to low nibble

loc_43a7:                                                       ; ...
43A7: E6 0F       and     $F
43A9: F5          push    af                              ; zero digit?
43AA: 28 21       jr      Z,handle_padding_43cd               ; yes,go
43AC: 32 2B E0    ld      (non_zero_digit_e02b),a             ; flag a non-zero digit

loc_43af:                                                       ; ...
43AF: F1          pop     af
43B0: C6 30       add     a,$30 ; '0'                  ; convert to ascii
43B2: 77          ld      (hl),a                         ; code    [unchecked_address]
43B3: CB D4       set     2,h                            ; ptr colour
43B5: 71          ld      (hl),c                         ; colour  [video_address]
43B6: CB 94       res     2,h                            ; ptr code

loc_43b8:                                                       ; ...
43B8: 3E 20       ld      a,$20 ; ' '
43BA: DF          rst     hl_plus_equals_a_0018                ; next column
43BB: 3A 2C E0    ld      a,(digits_to_print_e02c)
43BE: 3D          dec     a
43BF: 32 2C E0    ld      (digits_to_print_e02c),a            ; done all digits?
43C2: C8          ret     Z                               ; yes,return
43C3: E6 01       and     1                              ; high nibble next?
43C5: 20 03       jr      NZ,loc_43ca                    ; yes,skip
43C7: 18 D7       jr      loc_43a0                        ; next byte
; ---------------------------------------------------------------------------
43C9: C9          ret
; ---------------------------------------------------------------------------

loc_43ca:                                                       ; ...
43CA: 78          ld      a,b                            ; restore byte
43CB: 18 DA       jr      loc_43a7                        ; do nibble
; ---------------------------------------------------------------------------

handle_padding_43cd:                                                 ; ...
43CD: 3A 2B E0    ld      a,(non_zero_digit_e02b)
43D0: A7          and     a                               ; any non-zero?
43D1: 20 DC       jr      NZ,loc_43af                    ; yes,return
43D3: F1          pop     af                              ; fix stack
43D4: 18 E2       jr      loc_43b8                        ; continue printing
; End of function print_score_digits_4397


; =============== S U B R O U T I N E =======================================


check_objs_hit_43d6:                                                 ; ...

; FUNCTION CHUNK AT ROM:460A SIZE 00000063 BYTES

43D6: 3A 00 E0    ld      a,(vblank_tick_e000)
43D9: E6 01       and     1
43DB: CA 0A 46    jp      Z,check_player_bullets_hit_e200_e300_460a
43DE: CD D0 44    call    check_bomb_hit_large_or_e200_obj_44d0
43E1: CD F9 43    call    check_bomb_hit_e300_obj_43f9
43E4: CD 2A 45    call    check_player_bullets_hit_large_alien_452a
43E7: 3A 00 E1    ld      a,(ship_obj_e100)
43EA: 3C          inc     a                               ; active?
43EB: C0          ret     NZ                              ; no,exit
43EC: CD 7A 45    call    check_ship_hit_e200_obj_457a
43EF: CD C5 45    call    check_alien_bullet_hit_ship_45c5
43F2: CD CD 46    call    check_ship_hit_large_alien_46cd
43F5: CD 40 44    call    check_ship_hit_e300_obj_4440
43F8: C9          ret
; End of function check_objs_hit_43d6


; =============== S U B R O U T I N E =======================================


check_bomb_hit_e300_obj_43f9:                                        ; ...
43F9: 3A 50 E1    ld      a,(bomb_obj_e150)                   ; obj state
43FC: 3C          inc     a                               ; active?
43FD: C0          ret     NZ                              ; no,exit
43FE: 3A 06 EF    ld      a,(spriteram_shadow_ef00+6)         ; s1.y
4401: 67          ld      h,a                            ; save
4402: 3A 07 EF    ld      a,(spriteram_shadow_ef00+7)         ; s1.x
4405: 6F          ld      l,a                            ; save
4406: 16 09       ld      d,9                           ; hitbox
4408: 1E 13       ld      e,19                          ; cpl
440A: D9          exx
440B: 01 10 00    ld      bc,$10                       ; bytes per obj
440E: 11 04 00    ld      de,4                          ; bytes per sprite
4411: D9          exx
4412: DD 21 00 E3 ld      ix,e300_obj_tbl_e300
4416: FD 21 10 EF ld      iy,spriteram_shadow_ef00+0x10     ; s4.code
441A: 06 04       ld      b,4                           ; 4 objects to check

loc_441c:                                                       ; ...
441C: DD 7E 00    ld      a,(ix+$00)
441F: 3C          inc     a                               ; obj active?
4420: 20 15       jr      NZ,loc_4437                    ; no,skip
4422: FD 7E 02    ld      a,(iy+$02)                        ; obj sprite y
4425: 94          sub     h                               ; bomb sprite y
4426: 82          add     a,d                            ; hitbox
4427: BB          cp      e                               ; hit?
4428: 30 0D       jr      NC,loc_4437                    ; no,skip
442A: FD 7E 03    ld      a,(iy+$03)                        ; obj sprite x
442D: 95          sub     l                               ; bomb sprite x
442E: 82          add     a,d                            ; hitbox
442F: BB          cp      e                               ; hit?
4430: 30 05       jr      NC,loc_4437                    ; no,skip
4432: DD 36 00 6F ld      (ix+$00),$6F ; 'o'              ; flag obj explode???
4436: C9          ret
; ---------------------------------------------------------------------------

loc_4437:                                                       ; ...
4437: D9          exx
4438: FD 19       add     iy,de                          ; next sprite
443A: DD 09       add     ix,bc                          ; next obj
443C: D9          exx
443D: 10 DD       djnz    loc_441c                        ; loop
443F: C9          ret
; End of function check_bomb_hit_e300_obj_43f9


; =============== S U B R O U T I N E =======================================


check_ship_hit_e300_obj_4440:                                        ; ...
4440: 3A 00 E1    ld      a,(ship_obj_e100)
4443: 3C          inc     a                               ; active?
4444: C0          ret     NZ                              ; no,exit
4445: 3A 02 EF    ld      a,(spriteram_shadow_ef00+2)         ; s0.y
4448: 67          ld      h,a                            ; save
4449: 3A 03 EF    ld      a,(spriteram_shadow_ef00+3)         ; s0.x
444C: 6F          ld      l,a                            ; save

loc_444d:
444D: DD 21 00 E3 ld      ix,e300_obj_tbl_e300
4451: FD 21 10 EF ld      iy,spriteram_shadow_ef00+0x10     ; s4.code
4455: 16 06       ld      d,6                           ; hitbox add
4457: 1E 0D       ld      e,$D                         ; hitbox cp
4459: D9          exx
445A: 11 04 00    ld      de,4                          ; bytes per sprite
445D: 01 10 00    ld      bc,$10                       ; bytes per obj
4460: D9          exx
4461: 06 04       ld      b,4                           ; 4 objects to check

loc_4463:                                                       ; ...
4463: DD 7E 00    ld      a,(ix+$00)
4466: 3C          inc     a                               ; obj active?
4467: 20 1A       jr      NZ,loc_4483                    ; no,skip
4469: FD 7E 02    ld      a,(iy+$02)                        ; obj sprite y
446C: 94          sub     h                               ; ship sprite y
446D: 82          add     a,d                            ; hitbox
446E: BB          cp      e                               ; hit?
446F: 30 12       jr      NC,loc_4483                    ; no,skip
4471: FD 7E 03    ld      a,(iy+$03)                        ; obj sprite x
4474: 95          sub     l                               ; ship sprite x
4475: 82          add     a,d                            ; hitbox
4476: BB          cp      e                               ; hit?
4477: 30 0A       jr      NC,loc_4483                    ; no,skip
4479: DD 36 00 6F ld      (ix+$00),$6F ; 'o'              ; flag object explode
447D: 3E 3F       ld      a,$3F ; '?'
447F: 32 00 E1    ld      (ship_obj_e100),a                   ; flag ship explode
4482: C9          ret
; ---------------------------------------------------------------------------

loc_4483:                                                       ; ...
4483: D9          exx
4484: DD 09       add     ix,bc                          ; next object
4486: FD 19       add     iy,de                          ; next sprite
4488: D9          exx
4489: 10 D8       djnz    loc_4463                        ; loop
448B: C9          ret
; End of function check_ship_hit_e300_obj_4440


; =============== S U B R O U T I N E =======================================


check_bomb_hit_large_alien_448c:                                     ; ...
448C: 3A 06 EF    ld      a,(spriteram_shadow_ef00+6)         ; s1.y
448F: 67          ld      h,a                            ; save
4490: 3A 07 EF    ld      a,(spriteram_shadow_ef00+7)         ; s1.x
4493: 6F          ld      l,a                            ; save
4494: DD 21 60 E1 ld      ix,large_alien_obj_tbl_e160
4498: FD 21 08 EF ld      iy,spriteram_shadow_ef00+8        ; s2.code
449C: 11 08 00    ld      de,8
449F: 06 03       ld      b,3                           ; 3 objects to check

loc_44a1:                                                       ; ...
44A1: DD 7E 00    ld      a,(ix+$00)
44A4: 3C          inc     a                               ; object active?
44A5: 20 20       jr      NZ,loc_44c7                    ; no,skip
44A7: FD 7E 02    ld      a,(iy+$02)                        ; obj sprite y
44AA: 94          sub     h                               ; bomb sprite y
44AB: C6 18       add     a,24                          ; hitbox
44AD: FE 20       cp      32                             ; t?
44AF: 30 16       jr      NC,loc_44c7                    ; no,skip
44B1: FD 7E 03    ld      a,(iy+$03)                        ; obj sprite x
44B4: 95          sub     l                               ; bomb sprite x
44B5: C6 08       add     a,8                           ; hitbox
44B7: FE 10       cp      16                             ; hit?
44B9: 30 0C       jr      NC,loc_44c7                    ; no,skip
44BB: 3E 6F       ld      a,$6F ; 'o'
44BD: 32 50 E1    ld      (bomb_obj_e150),a                   ; flag explode?
44C0: DD 77 00    ld      (ix+$00),a                        ; obj state
44C3: DD 77 02    ld      (ix+$02),a                        ; ???
44C6: C9          ret
; ---------------------------------------------------------------------------

loc_44c7:                                                       ; ...
44C7: DD 19       add     ix,de
44C9: DD 19       add     ix,de                          ; next object
44CB: FD 19       add     iy,de                          ; next sprite (x2)
44CD: 10 D2       djnz    loc_44a1
44CF: C9          ret
; End of function check_bomb_hit_large_alien_448c


; =============== S U B R O U T I N E =======================================


check_bomb_hit_large_or_e200_obj_44d0:                               ; ...
44D0: 3A 50 E1    ld      a,(bomb_obj_e150)
44D3: 3C          inc     a                               ; active?
44D4: C0          ret     NZ                              ; no,exit
44D5: CD 8C 44    call    check_bomb_hit_large_alien_448c
44D8: 11 10 00    ld      de,$10
44DB: 01 04 00    ld      bc,4
44DE: D9          exx
44DF: 3A 06 EF    ld      a,(spriteram_shadow_ef00+6)         ; s1.y
44E2: 67          ld      h,a                            ; save
44E3: 3A 07 EF    ld      a,(spriteram_shadow_ef00+7)         ; s1.x
44E6: 6F          ld      l,a                            ; save
44E7: DD 21 00 E2 ld      ix,e200_obj_tbl_e200
44EB: FD 21 20 EF ld      iy,spriteram_shadow_ef00+0x20     ; s8.code
44EF: 06 09       ld      b,9                           ; 9 objects to check

loc_44f1:                                                       ; ...
44F1: DD 7E 00    ld      a,(ix+$00)
44F4: 3C          inc     a                               ; obj active?
44F5: 20 2A       jr      NZ,loc_4521                    ; no,skip
44F7: FD 7E 02    ld      a,(iy+$02)                        ; obj sprite y
44FA: 94          sub     h                               ; bomb sprite y
44FB: C6 0A       add     a,10                          ; hitbox
44FD: FE 15       cp      21                             ; hit?
44FF: 30 20       jr      NC,loc_4521                    ; no,skip
4501: FD 7E 03    ld      a,(iy+$03)                        ; obj sprite x
4504: 95          sub     l                               ; bomb sprite x
4505: C6 08       add     a,8                           ; hitbox
4507: FE 10       cp      16                             ; hit?
4509: 30 16       jr      NC,loc_4521                    ; no,skip
450B: DD 36 00 3F ld      (ix+$00),$3F ; '?'              ; flag obj explode???
450F: 3A 54 E1    ld      a,(bomb_obj_e150+4)                 ; bomb hit count
4512: DD 77 01    ld      (ix+$01),a                        ; copy to obj counter
4515: 3C          inc     a                               ; add hit
4516: 32 54 E1    ld      (bomb_obj_e150+4),a                 ; update bomb hit count
4519: DD 36 02 3C ld      (ix+$02),60                      ; init obj timer_e025
451D: DD 36 0A FF ld      (ix+$0a),$FF                  ; dy_dx lookup table index (none)

loc_4521:                                                       ; ...
4521: D9          exx
4522: DD 19       add     ix,de                          ; next object
4524: FD 09       add     iy,bc                          ; next sprite
4526: D9          exx
4527: 10 C8       djnz    loc_44f1                        ; loop
4529: C9          ret
; End of function check_bomb_hit_large_or_e200_obj_44d0


; =============== S U B R O U T I N E =======================================


check_player_bullets_hit_large_alien_452a:                           ; ...
452A: DD 21 10 E1 ld      ix,bullet_obj_tbl_e110
452E: 0E 04       ld      c,4                           ; 4 bullets to check

loc_4530:                                                       ; ...
4530: DD 7E 00    ld      a,(ix+$00)
4533: 3C          inc     a                               ; bullet active?
4534: 28 09       jr      Z,check_bullet_hit_3_large_alien_453f ; yes,go

loc_4536:                                                       ; ...
4536: 11 10 00    ld      de,$10
4539: DD 19       add     ix,de                          ; next bullet
453B: 0D          dec     c
453C: 20 F2       jr      NZ,loc_4530                    ; loop
453E: C9          ret
; ---------------------------------------------------------------------------

check_bullet_hit_3_large_alien_453f:                                 ; ...
453F: FD 21 08 EF ld      iy,spriteram_shadow_ef00+8        ; s2.code
4543: 21 60 E1    ld      hl,large_alien_obj_tbl_e160
4546: 06 03       ld      b,3                           ; 3 objects to check

loc_4548:                                                       ; ...
4548: 7E          ld      a,(hl)
4549: 3C          inc     a                               ; obj active?
454A: 20 22       jr      NZ,loc_456e                    ; no,skip
454C: DD 7E 01    ld      a,(ix+$01)                        ; bullet sprite y
454F: FD 96 02    sub     (iy+$02)                           ; obj sprite y
4552: C6 13       add     a,19                          ; hitbox
4554: FE 2C       cp      44                             ; hit?
4556: 30 16       jr      NC,loc_456e                    ; no,skip
4558: DD 7E 03    ld      a,(ix+$03)                        ; bullet sprite x
455B: FD 96 03    sub     (iy+$03)                           ; obj sprite x
455E: C6 06       add     a,6                           ; hitbox
4560: FE 0D       cp      13                             ; hit?
4562: 30 0A       jr      NC,loc_456e                    ; no,skip
4564: DD 36 00 3F ld      (ix+$00),$3F ; '?'              ; flag bullet explode
4568: 36 6F       ld      (hl),$6F ; 'o'               ; flag object hit
456A: 2C          inc     l
456B: 2C          inc     l
456C: 34          inc     (hl)                            ; inc obj hit count
456D: C9          ret
; ---------------------------------------------------------------------------

loc_456e:                                                       ; ...
456E: 11 08 00    ld      de,8
4571: FD 19       add     iy,de                          ; next sprite
4573: 19          add     hl,de
4574: 19          add     hl,de                          ; next obj
4575: 10 D1       djnz    loc_4548                        ; loop
4577: C3 36 45    jp      loc_4536                        ; next bullet
; End of function check_player_bullets_hit_large_alien_452a


; =============== S U B R O U T I N E =======================================


check_ship_hit_e200_obj_457a:                                        ; ...
457A: 3A 02 EF    ld      a,(spriteram_shadow_ef00+2)         ; s0.y
457D: 57          ld      d,a                            ; save
457E: 3A 03 EF    ld      a,(spriteram_shadow_ef00+3)         ; s0.x
4581: 5F          ld      e,a                            ; save
4582: 26 0B       ld      h,11                          ; hitbox add
4584: 2E 17       ld      l,23                          ; hitbox cp
4586: D9          exx
4587: FD 21 20 EF ld      iy,spriteram_shadow_ef00+0x20     ; s8.code
458B: DD 21 00 E2 ld      ix,e200_obj_tbl_e200
458F: 06 09       ld      b,9                           ; 9 objects
4591: CD 9E 45    call    check_collision_459e
4594: D0          ret     NC                              ; no collision,return
4595: 3E 3F       ld      a,$3F ; '?'                  ; flag explode???
4597: 32 00 E1    ld      (ship_obj_e100),a
459A: DD 77 00    ld      (ix+$00),a
459D: C9          ret
; End of function check_ship_hit_e200_obj_457a


; =============== S U B R O U T I N E =======================================


check_collision_459e:                                                ; ...
459E: D9          exx
459F: DD 7E 00    ld      a,(ix+$00)
45A2: 3C          inc     a                               ; obj active?
45A3: 20 11       jr      NZ,loc_45b6                    ; no,skip
45A5: FD 7E 02    ld      a,(iy+$02)                        ; obj sprite y
45A8: 92          sub     d                               ; ship sprite y
45A9: 84          add     a,h
45AA: BD          cp      l                               ; match?
45AB: 30 09       jr      NC,loc_45b6                    ; no,skip
45AD: FD 7E 03    ld      a,(iy+$03)                        ; obj sprite x
45B0: 93          sub     e                               ; ship sprite x
45B1: 84          add     a,h
45B2: BD          cp      l                               ; match?
45B3: 30 01       jr      NC,loc_45b6                    ; no,skip
45B5: C9          ret
; ---------------------------------------------------------------------------

loc_45b6:                                                       ; ...
45B6: D9          exx
45B7: 11 04 00    ld      de,4
45BA: FD 19       add     iy,de                          ; next sprite
45BC: 11 10 00    ld      de,$10
45BF: DD 19       add     ix,de                          ; next object
45C1: 10 DB       djnz    check_collision_459e
45C3: AF          xor     a                               ; clear collision flag
45C4: C9          ret
; End of function check_collision_459e


; =============== S U B R O U T I N E =======================================


check_alien_bullet_hit_ship_45c5:                                    ; ...
45C5: 3A 02 EF    ld      a,(spriteram_shadow_ef00+2)         ; s0.y
45C8: 57          ld      d,a                            ; save
45C9: 3A 03 EF    ld      a,(spriteram_shadow_ef00+3)         ; s0.x
45CC: 5F          ld      e,a                            ; save
45CD: 26 05       ld      h,5                           ; hitbox add
45CF: 2E 0B       ld      l,$B                         ; hitbox cpl
45D1: D9          exx
45D2: DD 21 A0 E2 ld      ix,alien_bullet_obj_tbl_e2a0
45D6: FD 21 44 EF ld      iy,spriteram_shadow_ef00+0x44     ; s17.code
45DA: 06 06       ld      b,6                           ; 6 objects to check

loc_45dc:                                                       ; ...
45DC: D9          exx
45DD: DD 7E 00    ld      a,(ix+$00)
45E0: 3C          inc     a                               ; obj active?
45E1: 20 19       jr      NZ,loc_45fc                    ; no,skip
45E3: FD 7E 02    ld      a,(iy+$02)                        ; obj sprite y
45E6: 92          sub     d                               ; ship sprite y
45E7: 84          add     a,h                            ; hitbox
45E8: BD          cp      l                               ; match?
45E9: 30 11       jr      NC,loc_45fc                    ; no,skip
45EB: FD 7E 03    ld      a,(iy+$03)                        ; obj sprite x
45EE: 93          sub     e                               ; ship sprite x
45EF: 84          add     a,h                            ; hitbox
45F0: BD          cp      l                               ; match?
45F1: 30 09       jr      NC,loc_45fc                    ; no,skip
45F3: 3E 3F       ld      a,$3F ; '?'                  ; explode???
45F5: DD 77 00    ld      (ix+$00),a                        ; update obj state
45F8: 32 00 E1    ld      (ship_obj_e100),a                   ; update ship state
45FB: C9          ret
; ---------------------------------------------------------------------------

loc_45fc:                                                       ; ...
45FC: D9          exx
45FD: 11 04 00    ld      de,4
4600: FD 19       add     iy,de
4602: 11 10 00    ld      de,$10
4605: DD 19       add     ix,de
4607: 10 D3       djnz    loc_45dc
4609: C9          ret
; End of function check_alien_bullet_hit_ship_45c5

; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR check_objs_hit_43d6

check_player_bullets_hit_e200_e300_460a:                             ; ...
460A: CD 6D 46    call    check_player_bullets_hit_9_obj_e200_466d
460D: 01 04 00    ld      bc,4
4610: 11 10 00    ld      de,$10
4613: D9          exx
4614: DD 21 10 E1 ld      ix,bullet_obj_tbl_e110
4618: 0E 04       ld      c,4                           ; 4 bullets to check
461A: 11 1A 06    ld      de,$61A                      ; hitbox add,cpl

loc_461d:                                                       ; ...
461D: DD 7E 00    ld      a,(ix+$00)                        ; bullet obj state
4620: 3C          inc     a                               ; active?
4621: CA 2D 46    jp      Z,loc_462d                     ; yes,go

loc_4624:                                                       ; ...
4624: D9          exx

loc_4625:                                                       ; ...
4625: DD 19       add     ix,de                          ; next object
4627: D9          exx
4628: 0D          dec     c                               ; bullet cnt
4629: C2 1D 46    jp      NZ,loc_461d                    ; loop
462C: C9          ret
; ---------------------------------------------------------------------------

loc_462d:                                                       ; ...
462D: DD 66 01    ld      h,(ix+$01)                        ; bullet y msb
4630: DD 6E 03    ld      l,(ix+$03)                        ; bullet x msb
4633: 06 04       ld      b,4                           ; 4 objects to check
4635: FD 21 10 EF ld      iy,spriteram_shadow_ef00+0x10     ; s4.code
4639: D9          exx
463A: 21 00 E3    ld      hl,e300_obj_tbl_e300

loc_463d:                                                       ; ...
463D: 7E          ld      a,(hl)                         ; obj state
463E: D9          exx
463F: 3C          inc     a                               ; active?
4640: C2 5F 46    jp      NZ,loc_465f                    ; no,skip
4643: FD 7E 02    ld      a,(iy+$02)                        ; sprite y
4646: 94          sub     h                               ; bullet y msb
4647: 82          add     a,d                            ; hitbox
4648: BB          cp      e                               ; hit?
4649: D2 5F 46    jp      NC,loc_465f                    ; no ,skip
464C: FD 7E 03    ld      a,(iy+$03)                        ; sprite x
464F: 95          sub     l                               ; bullet x msb
4650: 82          add     a,d                            ; hitbox
4651: BB          cp      e                               ; hit?
4652: D2 5F 46    jp      NC,loc_465f                    ; no ,skip
4655: D9          exx
4656: 3E 3F       ld      a,$3F ; '?'                  ; obj state
4658: 77          ld      (hl),a                         ; update obj state
4659: DD 77 00    ld      (ix+$00),a                        ; update bullet state
465C: C3 25 46    jp      loc_4625                        ; next bullet
; ---------------------------------------------------------------------------

loc_465f:                                                       ; ...
465F: D9          exx
4660: 19          add     hl,de                          ; next object
4661: FD 09       add     iy,bc                          ; next sprite
4663: D9          exx
4664: 10 03       djnz    loc_4669                        ; loop
4666: C3 24 46    jp      loc_4624                        ; next object
; ---------------------------------------------------------------------------

loc_4669:                                                       ; ...
4669: D9          exx
466A: C3 3D 46    jp      loc_463d                        ; next object
; END OF FUNCTION CHUNK FOR check_objs_hit_43d6

; =============== S U B R O U T I N E =======================================


check_player_bullets_hit_9_obj_e200_466d:                            ; ...
466D: 01 04 00    ld      bc,4
4670: 11 10 00    ld      de,$10
4673: D9          exx
4674: DD 21 10 E1 ld      ix,bullet_obj_tbl_e110
4678: 0E 04       ld      c,4                           ; 4 bullets to check
467A: 11 1A 06    ld      de,$61A

loc_467d:                                                       ; ...
467D: DD 7E 00    ld      a,(ix+$00)                        ; bullet state
4680: 3C          inc     a                               ; active?
4681: CA 8D 46    jp      Z,check_bullet_hit_9_e200_468d      ; yes,go

loc_4684:                                                       ; ...
4684: D9          exx

loc_4685:                                                       ; ...
4685: DD 19       add     ix,de                          ; next object
4687: D9          exx
4688: 0D          dec     c                               ; bullet cnt
4689: C2 7D 46    jp      NZ,loc_467d                    ; loop
468C: C9          ret
; ---------------------------------------------------------------------------

check_bullet_hit_9_e200_468d:                                        ; ...
468D: DD 66 01    ld      h,(ix+$01)                        ; bullet y msb
4690: DD 6E 03    ld      l,(ix+$03)                        ; bullet x msb
4693: 06 09       ld      b,9                           ; 9 objects to check
4695: FD 21 20 EF ld      iy,spriteram_shadow_ef00+0x20     ; s8.code
4699: D9          exx
469A: 21 00 E2    ld      hl,e200_obj_tbl_e200

loc_469d:                                                       ; ...
469D: 7E          ld      a,(hl)                         ; obj state
469E: D9          exx
469F: 3C          inc     a                               ; obj active?
46A0: C2 BF 46    jp      NZ,loc_46bf                    ; no,skip
46A3: FD 7E 02    ld      a,(iy+$02)                        ; sprite y
46A6: 94          sub     h                               ; bullet y msb
46A7: 82          add     a,d                            ; hitbox
46A8: BB          cp      e                               ; hit?
46A9: D2 BF 46    jp      NC,loc_46bf                    ; no,skip
46AC: FD 7E 03    ld      a,(iy+$03)                        ; obj x msb
46AF: 95          sub     l                               ; bullet x msb
46B0: 82          add     a,d                            ; hitbox
46B1: BB          cp      e                               ; hit?
46B2: D2 BF 46    jp      NC,loc_46bf                    ; no,skip
46B5: D9          exx
46B6: 3E 3F       ld      a,$3F ; '?'                  ; state = ???
46B8: 77          ld      (hl),a                         ; update obj state
46B9: DD 77 00    ld      (ix+$00),a                        ; update bullet state
46BC: C3 85 46    jp      loc_4685                        ; next bullet
; ---------------------------------------------------------------------------

loc_46bf:                                                       ; ...
46BF: D9          exx
46C0: 19          add     hl,de                          ; next object
46C1: FD 09       add     iy,bc                          ; next sprite
46C3: D9          exx
46C4: 10 03       djnz    loc_46c9                        ; loop
46C6: C3 84 46    jp      loc_4684
; ---------------------------------------------------------------------------

loc_46c9:                                                       ; ...
46C9: D9          exx
46CA: C3 9D 46    jp      loc_469d
; End of function check_player_bullets_hit_9_obj_e200_466d


; =============== S U B R O U T I N E =======================================


check_ship_hit_large_alien_46cd:                                     ; ...
46CD: 3A 02 EF    ld      a,(spriteram_shadow_ef00+2)         ; s0.y
46D0: 67          ld      h,a                            ; save
46D1: 3A 03 EF    ld      a,(spriteram_shadow_ef00+3)         ; s0.x
46D4: 6F          ld      l,a                            ; save
46D5: DD 21 60 E1 ld      ix,large_alien_obj_tbl_e160
46D9: FD 21 08 EF ld      iy,spriteram_shadow_ef00+8        ; s2.code
46DD: 06 03       ld      b,3                           ; 3 objects to check

loc_46df:                                                       ; ...
46DF: DD 7E 00    ld      a,(ix+$00)
46E2: 3C          inc     a                               ; object active?
46E3: 20 22       jr      NZ,loc_4707                    ; no,skip
46E5: FD 7E 02    ld      a,(iy+$02)                        ; obj sprite y
46E8: 94          sub     h                               ; ship sprite y
46E9: C6 1B       add     a,27                          ; hitbox
46EB: FE 26       cp      38                             ; match?
46ED: 30 18       jr      NC,loc_4707                    ; no,skip
46EF: FD 7E 03    ld      a,(iy+$03)                        ; obj sprite x
46F2: 95          sub     l                               ; ship sprite x
46F3: C6 1C       add     a,28                          ; hitbox
46F5: FE 29       cp      41                             ; match?
46F7: 30 0E       jr      NC,loc_4707                    ; no,skip
46F9: 3E 6F       ld      a,$6F ; 'o'
46FB: DD 77 00    ld      (ix+$00),a                        ; object state
46FE: DD 77 02    ld      (ix+$02),a                        ; hit count
4701: 3E 3F       ld      a,$3F ; '?'                  ; exploding?
4703: 32 00 E1    ld      (ship_obj_e100),a                   ; update state
4706: C9          ret
; ---------------------------------------------------------------------------

loc_4707:                                                       ; ...
4707: 11 08 00    ld      de,8
470A: DD 19       add     ix,de
470C: DD 19       add     ix,de
470E: FD 19       add     iy,de
4710: 10 CD       djnz    loc_46df
4712: C9          ret
; End of function check_ship_hit_large_alien_46cd


; =============== S U B R O U T I N E =======================================


play_pickup_snd_4713:                                                ; ...

; FUNCTION CHUNK AT ROM:47AE SIZE 00000010 BYTES

4713: 3A 05 E0    ld      a,(vbl_lvl_0_fn_e005)
4716: 3D          dec     a                               ; attract mode?
4717: 20 05       jr      NZ,loc_471e                    ; no,go
4719: 3A 19 E0    ld      a,(demo_sounds_e019)
471C: A7          and     a                               ; demo sounds ON?
471D: C8          ret     Z                               ; no,exit

loc_471e:                                                       ; ...
471E: 3E 10       ld      a,16
4720: C3 AE 47    jp      add_to_snd_q_47ae
; End of function play_pickup_snd_4713


; =============== S U B R O U T I N E =======================================


snd_cmd_07_4723:                                                     ; ...
4723: 3E 07       ld      a,7
4725: C3 AE 47    jp      add_to_snd_q_47ae
; End of function snd_cmd_07_4723


; =============== S U B R O U T I N E =======================================


snd_cmd_01_4728:                                                     ; ...
4728: 3A 05 E0    ld      a,(vbl_lvl_0_fn_e005)
472B: 3D          dec     a                               ; attract mode?
472C: 20 05       jr      NZ,loc_4733                    ; no,go
472E: 3A 19 E0    ld      a,(demo_sounds_e019)
4731: A7          and     a                               ; demo sounds ON?
4732: C8          ret     Z                               ; no,exit

loc_4733:                                                       ; ...
4733: 3E 01       ld      a,1
4735: C3 AE 47    jp      add_to_snd_q_47ae
; End of function snd_cmd_01_4728


; =============== S U B R O U T I N E =======================================


snd_cmd_04_4738:                                                     ; ...
4738: 3A 05 E0    ld      a,(vbl_lvl_0_fn_e005)
473B: 3D          dec     a                               ; attract mode?
473C: 20 05       jr      NZ,loc_4743                    ; no,go
473E: 3A 19 E0    ld      a,(demo_sounds_e019)
4741: A7          and     a                               ; demo sounds ON?
4742: C8          ret     Z                               ; no,exit

loc_4743:                                                       ; ...
4743: 3E 04       ld      a,4
4745: C3 AE 47    jp      add_to_snd_q_47ae
; End of function snd_cmd_04_4738


; =============== S U B R O U T I N E =======================================


play_bomb_snd_4748:                                                  ; ...
4748: 3A 05 E0    ld      a,(vbl_lvl_0_fn_e005)
474B: 3D          dec     a
474C: 20 05       jr      NZ,loc_4753
474E: 3A 19 E0    ld      a,(demo_sounds_e019)
4751: A7          and     a                               ; demo sounds ON?
4752: C8          ret     Z                               ; no,exit

loc_4753:                                                       ; ...
4753: 3E 20       ld      a,32
4755: C3 AE 47    jp      add_to_snd_q_47ae
; End of function play_bomb_snd_4748


; =============== S U B R O U T I N E =======================================


stop_bomb_snd_4758:                                                  ; ...
4758: 3E 30       ld      a,48
475A: C3 AE 47    jp      add_to_snd_q_47ae
; End of function stop_bomb_snd_4758


; =============== S U B R O U T I N E =======================================


play_bullet_snd_475d:                                                ; ...
475D: 3A 05 E0    ld      a,(vbl_lvl_0_fn_e005)
4760: 3D          dec     a                               ; attract mode?
4761: 20 05       jr      NZ,loc_4768                    ; no,go
4763: 3A 19 E0    ld      a,(demo_sounds_e019)
4766: A7          and     a                               ; demo sounds ON?
4767: C8          ret     Z                               ; no,exit

loc_4768:                                                       ; ...
4768: 3E 05       ld      a,5
476A: C3 AE 47    jp      add_to_snd_q_47ae
; End of function play_bullet_snd_475d


; =============== S U B R O U T I N E =======================================


play_snd_128_476d:                                                   ; ...
476D: 3A 05 E0    ld      a,(vbl_lvl_0_fn_e005)
4770: 3D          dec     a                               ; attract mode?
4771: 20 05       jr      NZ,loc_4778                    ; no,go
4773: 3A 18 E0    ld      a,(demo_music_e018)
4776: A7          and     a                               ; demo music ON?
4777: C8          ret     Z                               ; no,exit

loc_4778:                                                       ; ...
4778: 3E 80       ld      a,128
477A: C3 AE 47    jp      add_to_snd_q_47ae
; End of function play_snd_128_476d


; =============== S U B R O U T I N E =======================================


snd_cmd_03_477d:                                                     ; ...
477D: 3A 05 E0    ld      a,(vbl_lvl_0_fn_e005)
4780: 3D          dec     a                               ; attract mode?
4781: 20 05       jr      NZ,loc_4788                    ; no,skip
4783: 3A 19 E0    ld      a,(demo_sounds_e019)
4786: A7          and     a                               ; demo sounds ON?
4787: C8          ret     Z                               ; no,exit

loc_4788:                                                       ; ...
4788: 3E 03       ld      a,3
478A: C3 AE 47    jp      add_to_snd_q_47ae
; End of function snd_cmd_03_477d


; =============== S U B R O U T I N E =======================================


snd_cmd_02_478d:                                                     ; ...
478D: 3A 05 E0    ld      a,(vbl_lvl_0_fn_e005)
4790: 3D          dec     a                               ; attract mode?
4791: 20 05       jr      NZ,loc_4798                    ; no,skip
4793: 3A 19 E0    ld      a,(demo_sounds_e019)
4796: A7          and     a                               ; demo sounds ON?
4797: C8          ret     Z                               ; no,exit

loc_4798:                                                       ; ...
4798: 3E 02       ld      a,2
479A: C3 AE 47    jp      add_to_snd_q_47ae
; End of function snd_cmd_02_478d


; =============== S U B R O U T I N E =======================================


snd_cmd_08_479d:                                                     ; ...
479D: 3E 08       ld      a,8
479F: C3 AE 47    jp      add_to_snd_q_47ae
; End of function snd_cmd_08_479d


; =============== S U B R O U T I N E =======================================


nullsub_2_47a2:                                                      ; ...
47A2: C9          ret
; End of function nullsub_2_47a2

; ---------------------------------------------------------------------------
47A3: 21 02 C8    ld      hl,scroll_low_c802
47A6: CB 96       res     2,(hl)
47A8: CB D6       set     2,(hl)
47AA: 00          nop
47AB: CB 96       res     2,(hl)
47AD: C9          ret
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR play_pickup_snd_4713

add_to_snd_q_47ae:                                                   ; ...
47AE: 2A A6 ED    ld      hl,(snd_buffer_end_eda6)
47B1: 77          ld      (hl),a
47B2: 23          inc     hl
47B3: 7D          ld      a,l
47B4: FE A0       cp      $A0 ; '�'                     ; end of buffer?
47B6: 38 02       jr      C,loc_47ba                     ; no,skip
47B8: 2E 80       ld      l,$80 ; '�'                  ; wrap buffer

loc_47ba:                                                       ; ...
47BA: 22 A6 ED    ld      (snd_buffer_end_eda6),hl
47BD: C9          ret
; END OF FUNCTION CHUNK FOR play_pickup_snd_4713

; =============== S U B R O U T I N E =======================================


write_next_snd_cmd_47be:                                             ; ...
47BE: 0E 00       ld      c,0
47C0: 2A A8 ED    ld      hl,(snd_buffer_start_eda8)
47C3: 7E          ld      a,(hl)
47C4: 3C          inc     a                               ; $ff?
47C5: 28 0C       jr      Z,loc_47d3                     ; yes,skip
47C7: 3D          dec     a                               ; restore
47C8: 4F          ld      c,a                            ; save
47C9: 36 FF       ld      (hl),$FF                     ; flag $ff
47CB: 23          inc     hl                              ; next
47CC: 7D          ld      a,l
47CD: FE A0       cp      $A0 ; '�'                     ; end of buffer?
47CF: 38 02       jr      C,loc_47d3                     ; no,skip
47D1: 2E 80       ld      l,$80 ; '�'                  ; wrap

loc_47d3:                                                       ; ...
47D3: 22 A8 ED    ld      (snd_buffer_start_eda8),hl          ; store ptr
47D6: 79          ld      a,c
47D7: 32 80 EF    ld      (soundlatch_shadow_ef80),a
47DA: C9          ret
; End of function write_next_snd_cmd_47be

; [00000001 BYTES: COLLAPSED FUNCTION nullsub_3. PRESS CTRL-NUMPAD+ TO EXPAND]
nullsub_47db:
47DB: C9          ret

; =============== S U B R O U T I N E =======================================


init_curr_player_map_data_47dc:                                      ; ...
47DC: DD 21 A0 E1 ld      ix,curr_player_map_data_e1a0
47E0: AF          xor     a
47E1: DD 77 00    ld      (ix+$00),a
47E4: DD 77 01    ld      (ix+$01),a
47E7: DD 77 02    ld      (ix+$02),a
47EA: DD 77 03    ld      (ix+$03),a
47ED: DD 77 04    ld      (ix+$04),a
47F0: DD 77 05    ld      (ix+$05),a
47F3: DD 36 06 11 ld      (ix+$06),17
47F7: 21 60 48    ld      hl,area_meta_data_offset_tbl_4860
47FA: 3A 03 E5    ld      a,(map_area_e503)
47FD: EF          rst     de_eq_contents_hl_plus_2a_0028
47FE: DD 72 07    ld      (ix+$07),d
4801: DD 73 08    ld      (ix+$08),e                        ; offset into meta-data
4804: DD 36 09 0C ld      (ix+$09),12
4808: 3A 02 E5    ld      a,(map_planet_e502)
480B: FE 03       cp      3
480D: 38 08       jr      C,loc_4817
480F: D6 03       sub     3
4811: FE 03       cp      3
4813: 38 02       jr      C,loc_4817
4815: D6 03       sub     3

loc_4817:                                                       ; ...
4817: 87          add     a,a                            ; x2
4818: DD 77 13    ld      (ix+$13),a                     ; $E1B3 (map_planet_space_e1b3)
481B: 87          add     a,a                            ; x4
481C: 21 80 48    ld      hl,map_meta_data_tbl_4880
481F: EF          rst     de_eq_contents_hl_plus_2a_0028       ; += x8 get entry for this map
4820: DD 72 11    ld      (ix+$11),d
4823: DD 73 12    ld      (ix+$12),e                     ; ptr map meta-tile data
4826: 7E          ld      a,(hl)
4827: 23          inc     hl
4828: DD 77 0D    ld      (ix+$0D),a
482B: 7E          ld      a,(hl)
482C: 23          inc     hl
482D: DD 77 0C    ld      (ix+$0C),a                      ; ptr map code data
4830: 7E          ld      a,(hl)
4831: 23          inc     hl
4832: DD 77 0F    ld      (ix+$0f),a
4835: 7E          ld      a,(hl)
4836: 23          inc     hl
4837: DD 77 0E    ld      (ix+$0E),a                      ; ptr map palette data
483A: 7E          ld      a,(hl)
483B: 32 83 EF    ld      (palette_bank_shadow_ef83),a
483E: 21 00 D8    ld      hl,bgvideoram_code_d800
4841: DD 74 0A    ld      (ix+$0a),h
4844: DD 75 0B    ld      (ix+$0B),l                      ; ptr bg videoram render address
4847: 21 64 00    ld      hl,$64 ; 'd'
484A: 22 46 E0    ld      (scroll_plus1_shadow_e046),hl
484D: 21 80 00    ld      hl,$80 ; '�'
4850: 22 44 E0    ld      (scroll_shadow_e044),hl
4853: 21 00 10    ld      hl,$1000
4856: DD 74 14    ld      (ix+$14),h
4859: DD 75 15    ld      (ix+$15),l
485C: DD 75 16    ld      (ix+$16),l
485F: C9          ret
; End of function init_curr_player_map_data_47dc

; =============== S U B R O U T I N E =======================================


build_bg_prerender_and_test_4898:                                    ; ...
4898: CD AA 48    call    build_bg_prerender_buffer_48aa
489B: DD 7E 06    ld      a,(ix+$06)
489E: 32 48 E0    ld      (bg_lines_to_render_e048),a
48A1: DD 35 06    dec     (ix+$06)                           ; update lines to render
48A4: C0          ret     NZ                              ; more,return
48A5: AF          xor     a
48A6: 32 46 E0    ld      (scroll_plus1_shadow_e046),a
48A9: C9          ret
; End of function build_bg_prerender_and_test_4898


; =============== S U B R O U T I N E =======================================


build_bg_prerender_buffer_48aa:                                      ; ...
48AA: DD 21 A0 E1 ld      ix,curr_player_map_data_e1a0
48AE: FD 21 50 E0 ld      iy,bg_prerender_buffer_e050
48B2: 0E 08       ld      c,8                           ; 8x 4 tiles
48B4: DD 66 07    ld      h,(ix+$07)
48B7: DD 6E 08    ld      l,(ix+$08)                        ; offset into meta-data?
48BA: DD 56 11    ld      d,(ix+$11)
48BD: DD 5E 12    ld      e,(ix+$12)                     ; ptr map meta-tile data
48C0: 19          add     hl,de                          ; calc entry address

loc_48c1:                                                       ; ...
48C1: 7E          ld      a,(hl)
48C2: DD 77 10    ld      (ix+$10),a
48C5: D9          exx
48C6: E6 7F       and     $7F ; ''                     ; mask off flag
48C8: 6F          ld      l,a
48C9: 26 00       ld      h,0
48CB: 29          add     hl,hl                          ; x2
48CC: 29          add     hl,hl                          ; x4
48CD: 29          add     hl,hl                          ; x8
48CE: 29          add     hl,hl                          ; x16
48CF: DD 7E 09    ld      a,(ix+$09)
48D2: DD CB 10 7E bit     7,(ix+$10)                     ; flag set?
48D6: 20 06       jr      NZ,loc_48de                    ; yes,skip
48D8: DD 36 10 00 ld      (ix+$10),0                    ; colour adjustment=0
48DC: 18 08       jr      loc_48e6
; ---------------------------------------------------------------------------

loc_48de:                                                       ; ...
48DE: DD 36 10 20 ld      (ix+$10),$20 ; ' '           ; colour adjustment=32
48E2: 5F          ld      e,a                            ; 9(IX)
48E3: 3E 0C       ld      a,12
48E5: 93          sub     e                               ; 12-a

loc_48e6:                                                       ; ...
48E6: DF          rst     hl_plus_equals_a_0018
48E7: 54          ld      d,h
48E8: 5D          ld      e,l
48E9: DD 46 0C    ld      b,(ix+$0C)
48EC: DD 4E 0D    ld      c,(ix+$0D)                      ; ptr map tile code data (base)
48EF: 09          add     hl,bc                          ; calc entry address
48F0: EB          ex      de,hl
48F1: DD 46 0E    ld      b,(ix+$0E)
48F4: DD 4E 0F    ld      c,(ix+$0f)                      ; ptr map palette data
48F7: 09          add     hl,bc
48F8: 06 04       ld      b,4                           ; 4 tiles

loc_48fa:                                                       ; ...
48FA: 1A          ld      a,(de)                         ; get bg code
48FB: FD 77 00    ld      (iy+$00),a                        ; store in prerender buffer
48FE: 7E          ld      a,(hl)                         ; map colour lookup entry
48FF: DD 86 10    add     a,(ix+$10)                     ; calc actual colour
4902: FD 77 20    ld      (iy+$20),a                     ; store in prerender buffer
4905: 23          inc     hl                              ; next colour entry
4906: 13          inc     de                              ; next code entry
4907: FD 23       inc     iy                              ; next prerender addr
4909: 10 EF       djnz    loc_48fa                        ; loop
490B: D9          exx
490C: 23          inc     hl
490D: 0D          dec     c
490E: 20 B1       jr      NZ,loc_48c1                    ; loop
4910: DD 7E 09    ld      a,(ix+$09)
4913: D6 04       sub     4
4915: 47          ld      b,a
4916: E6 0C       and     $C
4918: DD 77 09    ld      (ix+$09),a
491B: CB 78       bit     7,b
491D: 28 15       jr      Z,loc_4934
491F: DD 66 07    ld      h,(ix+$07)
4922: DD 6E 08    ld      l,(ix+$08)
4925: 01 F8 FF    ld      bc,$FFF8                     ; -8
4928: 09          add     hl,bc
4929: 7C          ld      a,h
492A: FE 02       cp      2
492C: 30 1C       jr      NC,loc_494a
492E: DD 77 07    ld      (ix+$07),a
4931: DD 75 08    ld      (ix+$08),l

loc_4934:                                                       ; ...
4934: DD 66 0A    ld      h,(ix+$0a)
4937: DD 6E 0B    ld      l,(ix+$0B)                      ; ptr bg videoram address
493A: 22 49 E0    ld      (bg_prerender_ptr_e049),hl
493D: 3E 20       ld      a,$20 ; ' '
493F: DF          rst     hl_plus_equals_a_0018                ; next column
4940: 7C          ld      a,h
4941: E6 DB       and     $DB ; '�'                     ; handle wrap
4943: DD 77 0A    ld      (ix+$0a),a
4946: DD 75 0B    ld      (ix+$0B),l                      ; update
4949: C9          ret
; ---------------------------------------------------------------------------

loc_494a:                                                       ; ...
494A: DD 34 13    inc     (ix+$13)                        ; (map_planet_e502 % 3) x2
494D: DD 7E 13    ld      a,(ix+$13)
4950: FE 06       cp      6                              ; max?
4952: 38 04       jr      C,loc_4958                     ; no,skip
4954: DD 36 13 00 ld      (ix+$13),0                    ; wrap

loc_4958:                                                       ; ...
4958: DD 7E 13    ld      a,(ix+$13)                     ; (map_planet_e502 % 3) x2
495B: E6 01       and     1                              ; in space?
495D: 20 1E       jr      NZ,loc_497d                    ; yes,go
495F: 21 01 E5    ld      hl,byte_e501
4962: 34          inc     (hl)
4963: AF          xor     a
4964: 32 03 E5    ld      (map_area_e503),a                   ; reset area
4967: 3D          dec     a
4968: 32 1F E0    ld      (byte_e01f),a
496B: 3A 02 E5    ld      a,(map_planet_e502)
496E: 3C          inc     a
496F: FE 09       cp      9                              ; max?
4971: 38 01       jr      C,loc_4974                     ; no,skip
4973: AF          xor     a                               ; reset

loc_4974:                                                       ; ...
4974: 32 02 E5    ld      (map_planet_e502),a
4977: CD 2C 2B    call    reset_some_stuff_2b2c
497A: CD 46 2B    call    init_planet_area_data_2b46

loc_497d:                                                       ; ...
497D: 21 BE 49    ld      hl,planet_and_space_data_tbl_49be
4980: DD 7E 13    ld      a,(ix+$13)                     ; map_planet_space_e1b3
4983: 47          ld      b,a
4984: 87          add     a,a                            ; x2
4985: 87          add     a,a                            ; x4
4986: 87          add     a,a                            ; x8
4987: 80          add     a,b                            ; x9
4988: E7          rst     content_hl_plus_a_0020
4989: DD 77 08    ld      (ix+$08),a
498C: 23          inc     hl
498D: 7E          ld      a,(hl)
498E: DD 77 07    ld      (ix+$07),a                        ; offset into meta-data
4991: 23          inc     hl
4992: 7E          ld      a,(hl)
4993: DD 77 12    ld      (ix+$12),a
4996: 23          inc     hl
4997: 7E          ld      a,(hl)
4998: DD 77 11    ld      (ix+$11),a                     ; ptr map meta-tile data
499B: 23          inc     hl
499C: 7E          ld      a,(hl)
499D: DD 77 0D    ld      (ix+$0D),a
49A0: 23          inc     hl
49A1: 7E          ld      a,(hl)
49A2: DD 77 0C    ld      (ix+$0C),a                      ; ptr map tile code data (base)
49A5: 23          inc     hl
49A6: 7E          ld      a,(hl)
49A7: DD 77 0F    ld      (ix+$0f),a
49AA: 23          inc     hl
49AB: 7E          ld      a,(hl)
49AC: DD 77 0E    ld      (ix+$0E),a                      ; ptr map palette data
49AF: 23          inc     hl
49B0: 7E          ld      a,(hl)
49B1: 32 83 EF    ld      (palette_bank_shadow_ef83),a
49B4: AF          xor     a
49B5: DD 77 14    ld      (ix+$14),a
49B8: DD 77 15    ld      (ix+$15),a
49BB: C3 34 49    jp      loc_4934
; End of function build_bg_prerender_buffer_48aa

; ---------------------------------------------------------------------------
; 9 bytes per entry
; 0/1 - offset into meta data
; 2/3 - ptr meta data (base)
; 4/5 - ptr code data
; 6/7 - ptr colour data
;   8 - palette bank
;	.word 0x1F8                             ; ...
;	.word planet_1_meta_data_8000
;	.word planet_1_code_data_8200
;	.word planet_1_colour_data_8790
;	.word 0xB8
;	.word space_1_meta_data_586c
;	.word space_1_code_data_592c
;	.word space_1_colour_data_5b6c
;	.word 0x1F8
;	.word planet_2_meta_data_8d20
;	.word planet_2_code_data_8f20
;	.word planet_2_colour_data_95a0
;	.word 0xB8
;	.word space_2_meta_data_57ac
;	.word space_1_code_data_592c
;	.word space_1_colour_data_5b6c
;	.word 0x1F8
;	.word planet_3_meta_data_4aac
;	.word planet_3_code_data_4cac
;	.word planet_3_colour_data_51cc
;	.word 0xB8
;	.word space_3_meta_data_56ec
;	.word space_1_code_data_592c
;	.word space_1_colour_data_5b6c

; =============== S U B R O U T I N E =======================================


sub_49f4:                                                       ; ...
49F4: DD 21 A0 E1 ld      ix,curr_player_map_data_e1a0
49F8: 11 08 00    ld      de,8
49FB: DD 66 14    ld      h,(ix+$14)
49FE: DD 6E 15    ld      l,(ix+$15)
4A01: 19          add     hl,de
4A02: DD 74 14    ld      (ix+$14),h
4A05: DD 75 15    ld      (ix+$15),l
4A08: DD 6E 05    ld      l,(ix+$05)
4A0B: DD 66 04    ld      h,(ix+$04)
4A0E: DD 7E 03    ld      a,(ix+$03)
4A11: 11 80 00    ld      de,$80 ; '�'
4A14: 19          add     hl,de
4A15: CE 00       adc     a,0
4A17: E6 0F       and     $F
4A19: DD 77 03    ld      (ix+$03),a
4A1C: DD 74 04    ld      (ix+$04),h
4A1F: DD 75 05    ld      (ix+$05),l
4A22: 6C          ld      l,h
4A23: E6 01       and     1
4A25: 67          ld      h,a
4A26: 22 46 E0    ld      (scroll_plus1_shadow_e046),hl
4A29: 2A 0B E1    ld      hl,(ground_dy_e10b)
4A2C: AF          xor     a
4A2D: CB 7C       bit     7,h
4A2F: 28 01       jr      Z,loc_4a32
4A31: 2F          cpl

loc_4a32:                                                       ; ...
4A32: DD 46 00    ld      b,(ix+$00)
4A35: DD 56 01    ld      d,(ix+$01)
4A38: DD 5E 02    ld      e,(ix+$02)
4A3B: 19          add     hl,de                          ; move w/bg
4A3C: 88          adc     a,b
4A3D: DD 77 00    ld      (ix+$00),a
4A40: DD 74 01    ld      (ix+$01),h
4A43: DD 75 02    ld      (ix+$02),l
4A46: 6C          ld      l,h
4A47: E6 01       and     1
4A49: 67          ld      h,a
4A4A: 22 44 E0    ld      (scroll_shadow_e044),hl
4A4D: CD 5F 4A    call    sub_4a5f
4A50: 3A 00 E0    ld      a,(vblank_tick_e000)
4A53: E6 1F       and     $1F
4A55: C0          ret     NZ
4A56: CD AA 48    call    build_bg_prerender_buffer_48aa
4A59: 3E 01       ld      a,1
4A5B: 32 48 E0    ld      (bg_lines_to_render_e048),a
4A5E: C9          ret
; End of function sub_49f4


; =============== S U B R O U T I N E =======================================


sub_4a5f:                                                       ; ...
4A5F: DD 7E 16    ld      a,(ix+$16)
4A62: A7          and     a
4A63: 20 1A       jr      NZ,loc_4a7f
4A65: DD 7E 13    ld      a,(ix+$13)
4A68: E6 01       and     1
4A6A: C8          ret     Z
4A6B: DD 7E 15    ld      a,(ix+$15)
4A6E: A7          and     a
4A6F: C0          ret     NZ
4A70: DD 7E 14    ld      a,(ix+$14)
4A73: FE 18       cp      $18
4A75: 28 03       jr      Z,loc_4a7a
4A77: FE 50       cp      $50 ; 'P'
4A79: C0          ret     NZ

loc_4a7a:                                                       ; ...
4A7A: DD 36 16 FF ld      (ix+$16),$FF
4A7E: C9          ret
; ---------------------------------------------------------------------------

loc_4a7f:                                                       ; ...
4A7F: DD 35 16    dec     (ix+$16)
4A82: 28 09       jr      Z,loc_4a8d
4A84: 3A 00 E0    ld      a,(vblank_tick_e000)
4A87: E6 03       and     3
4A89: 32 83 EF    ld      (palette_bank_shadow_ef83),a
4A8C: C9          ret
; ---------------------------------------------------------------------------

loc_4a8d:                                                       ; ...
4A8D: DD 7E 14    ld      a,(ix+$14)
4A90: FE 30       cp      $30 ; '0'
4A92: 30 06       jr      NC,loc_4a9a
4A94: 3E 03       ld      a,3
4A96: 32 83 EF    ld      (palette_bank_shadow_ef83),a
4A99: C9          ret
; ---------------------------------------------------------------------------

loc_4a9a:                                                       ; ...
4A9A: DD 7E 13    ld      a,(ix+$13)
4A9D: 0F          rrca
4A9E: E6 03       and     3
4AA0: 21 A8 4A    ld      hl,palette_bank_tbl_4aa8
4AA3: E7          rst     content_hl_plus_a_0020
4AA4: 32 83 EF    ld      (palette_bank_shadow_ef83),a
4AA7: C9          ret
; End of function sub_4a5f

; ---------------------------------------------------------------------------
; variables for each planet 1-3,4-6,7-9
;	.word planet_1_area_data_tbl_5dbe              ; ...
;	.word planet_2_area_data_tbl_5f1e
;	.word planet_3_area_data_tbl_607e
;	.word planet_4_area_data_tbl_61de
;	.word planet_5_area_data_tbl_633e
;	.word planet_6_area_data_tbl_649e
;	.word planet_7_area_data_tbl_65fe
;	.word planet_8_area_data_tbl_675e
;	.word planet_9_area_data_tbl_68be
; Each planet has 22 blocks of 16-byte data
; - interesting because there are only 16 areas/planet?!?
; $0: max_alien_bullets
; $1: alien_fire_proximity_limit (every entry 0xA)
; $2: alien bullet timer_e025
; $4: adjustment to flying alien spawn threshold
; $5: firing alien type
; $6: E0BB timer_e025 init
; $7: firing alien spawn timer_e025
; $9: formation type (table entry index)
; $A: formation spawn timer_e025
; $B: large alien spawn [7:4]=count,[3:0]=type
; $D: large alien spawn timer_e025
; $E: non-firing alien type
; $F: formation alien type
; calculates a cluster of points around the ship
; to be used as targets for aliens to aim at

; =============== S U B R O U T I N E =======================================


update_aiming_table_6a1e:                                            ; ...
6A1E: 3A 00 E0    ld      a,(vblank_tick_e000)
6A21: E6 0F       and     $F
6A23: C0          ret     NZ
6A24: DD 21 80 E3 ld      ix,alien_aiming_tbl_e380
6A28: 3A 02 EF    ld      a,(spriteram_shadow_ef00+2)         ; s0.y
6A2B: DD 77 00    ld      (ix+$00),a
6A2E: DD 77 0E    ld      (ix+$0E),a
6A31: DD 77 10    ld      (ix+$10),a
6A34: DD 77 12    ld      (ix+$12),a
6A37: DD 77 14    ld      (ix+$14),a
6A3A: DD 77 16    ld      (ix+$16),a
6A3D: DD 77 18    ld      (ix+$18),a
6A40: C6 10       add     a,16
6A42: DD 77 04    ld      (ix+$04),a
6A45: C6 10       add     a,16
6A47: DD 77 08    ld      (ix+$08),a
6A4A: C6 10       add     a,16
6A4C: DD 77 0C    ld      (ix+$0C),a
6A4F: D6 40       sub     64
6A51: DD 77 02    ld      (ix+$02),a
6A54: D6 10       sub     16
6A56: DD 77 06    ld      (ix+$06),a
6A59: D6 10       sub     16
6A5B: DD 77 0A    ld      (ix+$0a),a
6A5E: 3A 03 EF    ld      a,(spriteram_shadow_ef00+3)         ; s0.x
6A61: DD 77 01    ld      (ix+$01),a
6A64: DD 77 03    ld      (ix+$03),a
6A67: DD 77 05    ld      (ix+$05),a
6A6A: DD 77 07    ld      (ix+$07),a
6A6D: DD 77 09    ld      (ix+$09),a
6A70: DD 77 0B    ld      (ix+$0B),a
6A73: DD 77 0D    ld      (ix+$0D),a
6A76: C6 10       add     a,16
6A78: DD 77 0F    ld      (ix+$0f),a
6A7B: C6 10       add     a,16
6A7D: DD 77 21    ld      (ix+$21),a
6A80: C6 10       add     a,16
6A82: DD 77 13    ld      (ix+$13),a
6A85: D6 40       sub     64
6A87: DD 77 15    ld      (ix+$15),a
6A8A: D6 10       sub     16
6A8C: DD 77 17    ld      (ix+$17),a
6A8F: D6 10       sub     16
6A91: DD 77 19    ld      (ix+$19),a
6A94: C9          ret
; End of function update_aiming_table_6a1e


; =============== S U B R O U T I N E =======================================


aim_directly_at_ship_6a95:                                           ; ...
6A95: 21 80 E3    ld      hl,alien_aiming_tbl_e380
6A98: 7E          ld      a,(hl)                         ; s0.y
6A99: C3 A4 6A    jp      loc_6aa4
; ---------------------------------------------------------------------------

aim_near_ship_6a9c:                                                  ; ...
6A9C: DD 7E 0F    ld      a,(ix+$0f)                      ; obj aiming entry
6A9F: 21 80 E3    ld      hl,alien_aiming_tbl_e380
6AA2: 87          add     a,a                            ; calc offset
6AA3: E7          rst     content_hl_plus_a_0020

loc_6aa4:                                                       ; ...
6AA4: 0E 00       ld      c,0
6AA6: 23          inc     hl                              ; ptr target x
6AA7: FD 46 02    ld      b,(iy+$02)                        ; sprite y
6AAA: 90          sub     b                               ; target-sprite y
6AAB: 28 74       jr      Z,loc_6b21                     ; same,go
6AAD: CB 19       rr      c
6AAF: CB 79       bit     7,c                            ; -ve?
6AB1: 28 02       jr      Z,loc_6ab5                     ; no,skip
6AB3: ED 44       neg                                     ; abs

loc_6ab5:                                                       ; ...
6AB5: 57          ld      d,a                            ; save abs(target-y)
6AB6: 7E          ld      a,(hl)                         ; target x
6AB7: FD 46 03    ld      b,(iy+$03)                        ; sprite x
6ABA: 90          sub     b                               ; target-sprite x
6ABB: 28 6F       jr      Z,loc_6b2c                     ; same,go
6ABD: CB 19       rr      c
6ABF: CB 79       bit     7,c                            ; -ve?
6AC1: 28 02       jr      Z,loc_6ac5                     ; no,skip
6AC3: ED 44       neg                                     ; abs

loc_6ac5:                                                       ; ...
6AC5: 5F          ld      e,a                            ; save abs(target-x)
6AC6: 92          sub     d                               ; delta x - delta y
6AC7: 28 65       jr      Z,loc_6b2e                     ; same,go
6AC9: CB 19       rr      c
6ACB: CB 79       bit     7,c                            ; -ve?
6ACD: 28 08       jr      Z,loc_6ad7                     ; no,go
6ACF: 6A          ld      l,d                            ; abs(delta y)
6AD0: 53          ld      d,e                            ; abs(delta x)
6AD1: 1E 00       ld      e,0
6AD3: 26 00       ld      h,0
6AD5: 18 05       jr      loc_6adc
; ---------------------------------------------------------------------------
; this makes my brain hurt!

loc_6ad7:                                                       ; ...
6AD7: 6B          ld      l,e                            ; abs(delta x)
6AD8: 1E 00       ld      e,0
6ADA: 26 00       ld      h,0

loc_6adc:                                                       ; ...
6ADC: 79          ld      a,c
6ADD: 08          ex      af,af'
6ADE: 3E 10       ld      a,16
6AE0: 44          ld      b,h
6AE1: 4D          ld      c,l
6AE2: 21 00 00    ld      hl,0

loc_6ae5:                                                       ; ...
6AE5: EB          ex      de,hl
6AE6: 29          add     hl,hl
6AE7: EB          ex      de,hl
6AE8: ED 6A       adc     hl,hl
6AEA: 1C          inc     e
6AEB: ED 42       sbc     hl,bc
6AED: 30 02       jr      NC,loc_6af1
6AEF: 1D          dec     e
6AF0: 09          add     hl,bc

loc_6af1:                                                       ; ...
6AF1: 3D          dec     a
6AF2: 20 F1       jr      NZ,loc_6ae5
6AF4: 7B          ld      a,e
6AF5: 0F          rrca
6AF6: 0F          rrca
6AF7: 0F          rrca
6AF8: E6 1F       and     $1F                           ; /8
6AFA: 47          ld      b,a                            ; store
6AFB: 08          ex      af,af'
6AFC: 07          rlca
6AFD: 07          rlca
6AFE: 07          rlca
6AFF: E6 07       and     7
6B01: 21 11 6B    ld      hl,byte_6b11
6B04: E7          rst     content_hl_plus_a_0020
6B05: 4F          ld      c,a                            ; save 1st byte
6B06: 3E 08       ld      a,8                           ; offset 2 2nd byte
6B08: E7          rst     content_hl_plus_a_0020               ; get 2nd byte
6B09: CB 41       bit     0,c                            ; add?
6B0B: 20 02       jr      NZ,loc_6b0f                    ; no,go
6B0D: 80          add     a,b                            ; (tbl entry) + b
6B0E: C9          ret
; ---------------------------------------------------------------------------

loc_6b0f:                                                       ; ...
6B0F: 90          sub     b                               ; (tbl entry) - b
6B10: C9          ret
; ---------------------------------------------------------------------------
; 1st 8 bytes: 0=add,1=sub
; 2nd 8 bytes: value to add/sub
; ---------------------------------------------------------------------------

loc_6b21:                                                       ; ...
6B21: 3A 03 EF    ld      a,(spriteram_shadow_ef00+3)         ; s0.x
6B24: 46          ld      b,(hl)
6B25: 90          sub     b
6B26: CB 19       rr      c
6B28: 3E 40       ld      a,$40 ; '@'
6B2A: 81          add     a,c
6B2B: C9          ret
; ---------------------------------------------------------------------------

loc_6b2c:                                                       ; ...
6B2C: 79          ld      a,c
6B2D: C9          ret
; ---------------------------------------------------------------------------

loc_6b2e:                                                       ; ...
6B2E: 79          ld      a,c
6B2F: 07          rlca
6B30: 07          rlca
6B31: E6 03       and     3
6B33: 21 38 6B    ld      hl,byte_6b38
6B36: E7          rst     content_hl_plus_a_0020
6B37: C9          ret
; End of function aim_directly_at_ship_6a95

; ---------------------------------------------------------------------------
; ***
; *** END OF CODE ***
; ***

; ===========================================================================

; *** the start of per-game variables
                                                ; *** UNUSED???
; each time flying objects are updated
; this value is initialised to the count of active flying aliens
; every 2nd timer_e025 tick,if >= 5,then decremented
; - (used to allow formations of 5/6 to be spawned)
; ship object
; $00 - state ($00=inactive,$01=exploding,$3f=explode,$ff=active)
; $01 - explosion frame cnt
; $02 - explosion frame tmr
; $06 - ship y lsb
; $07 - ship x lsb

; bullet object table (4 bullets x16 bytes)
; $00    - state ($00=inactive,$3f=hit,$ff=active)
; $01    - obj y msb (== sprite y)
; $02    - obj y lsb
; $03    - obj x msb (== sprite x)
; $04    - obj x lsb
; $05/06 - fg videoram addr

; bomb object table (1 bomb x16 bytes)
; $00 - state
; $01 - obj y lsb
; $02 - obj x lsb
; $03 - ???
; $04 - hit count

; large alien object table (3 entries)
; $00    - state ($00=inactive,$6f=hit,$ff=active)
; $01    - ???
; $02    - hit count
; $03    - y lsb
; $04    - x lsb
; $05    - type (0=viking,1=fly,2=bat,3=vulgus,4=vulgus_hit)
; $06/07 - dy
; $08/09 - dx
; $0A    -
; $0B    -
; $0C    -
; $0D    -

; pickup object table (1 entry)
; $01 - ???
; $05 - type (0=pow,1='E',2='S',3='D',4=star)
; $08 -
; $09 - ???

; $07/08 - offset into area meta data
; $0A/0B - ptr background RAM for next render line
; $0C/0D - ptr tile code data (base)
; $0E/0F - ptr planet map palette data
; $10    - colour adjustment
; $11/12 - ptr map meta-tile data
; $13    - (planet % 3) x2
; (planet % 3) x2 (+1 = outer space)

; $E200 (firing) object table
; $00    - state ($00=inactive,$3f=hit,$ff=active)
; $01    - counter???
; $02    - timer_e025???
; $03    - y lsb
; $04    - x lsb
; $05    - type (0=tumble_ship,1=plane,2=ray,3=butterfly,;                4=moth,5=bug,6=turtle,7=pincer_bug,;                8=star,9=spinning_disc,10-13=rock,RAM:E200                              15=jap_symbol->spinning_disc)
; $06/07 - dy
; $08/09 - dx
; $0A    - dy_dx lookup table index
; $0B    - (related to y)
; $0C    - (related to x)
; $0D    - ?
; $0E    - ?
; $0F    - aiming table entry

; alien bullet object table
; $00 - state ($00=inactive,$3f=hit,$ff=active)
; $02 - timer_e025???
; $05 - type?

; $E300 (non-firing) object table
; $00    - state ($00=inactive,$3f=hit,$ff=active)
; $01    - counter/flag??
; $02    - timer_e025???
; $05    - type (0=spinning_block,1=yashichi,2=eyeball,;                3-6=rock,7=spinning_disc)
; $06/07 - dy
; $08/09 - dx
; $0A/0B - ddy
; $0C/0D - ddx
; $0E    - ??? (used for vulgus)

; table of (y,x) pairs surrounding player ship
; - used for aliens for aiming at ship
; - some use 0 and fire directly
; - others use $f(ix) and fire nearby
;  0: (s0.y,s0.x)
;  1: (s0.y-16,s0.x)
;  2: (s0.y+16,s0.x)
;  3: (s0.y-32,s0.x)
;  4: (s0.y+32,s0.x)
;  5: (s0.y-48,s0.x)
;  6: (s0.y+48,s0.x)
;  7: (s0.y,s0.x+16)
;  8: (s0.y,s0.x+32)
;  9: (s0.y,s0.x+48)
; 10: (s0.y,s0.x-16)
; 11: (s0.y,s0.x-32)
; 12: (s0.y,s0.x-48)
; $E500 - curr player status
; $E520 port_1_c001 status
; $E540 port_2_c002 status

; shadow copy of spriteram_cc00
; - sprite allocation:
; 00    - $E100: player ship
; 01    - $E150: bomb
; 02-07 - $E160: large aliens (3x) (game mode only)
; 04-07 - $E110: bullets (4x) (attract mode only)
;       - $E300: special objs? (4x) (game mode only)
; 08-16 - $E160: large aliens (3x) (attract mode only)
;         $E200: flying objects (9x) (game mode only)
; 17-22 - $E2A0: alien bullets (6x)
; 23    - $E190: pickup objects (1x)
; end of 'RAM'

; end of file