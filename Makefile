include .env

ROMS= ~/roms
EMU= ~/bin/uxncli
ASM= $(EMU) $(ROMS)/drifblim.rom

SRC_DIR= ./day
OUT_DIR= ./bin
INPUT_DIR= ./input

TEMPLATE= ./template.tal
GRAB_SCRIPT= ./script/grab.tal

day := $(shell echo $(d) | grep -Eo '^[0-9]+')
part := $(shell echo $(d) | grep -Eo '[ab]$$')

$(OUT_DIR)/$(day)$(part).rom: $(SRC_DIR)/$(day)/$(part).tal
	@ mkdir -p $(OUT_DIR)
	@ $(ASM) $(SRC_DIR)/$(day)/$(part).tal $(OUT_DIR)/$(day)$(part).rom

$(OUT_DIR)/grab.rom:
	@ $(ASM) $(GRAB_SCRIPT) $(OUT_DIR)/grab.rom

$(INPUT_DIR)/$(day).input: $(OUT_DIR)/grab.rom
	@ mkdir -p $(INPUT_DIR)
	@ touch $(INPUT_DIR)/$(day).input
	@ $(EMU) $(OUT_DIR)/grab.rom $(YEAR) $(day) $(INPUT_DIR)/$(day).input $(AOC_SESSION)

.PHONY: run clean build grab generate
run: $(OUT_DIR)/$(day)$(part).rom $(INPUT_DIR)/$(day).input
	@ cat $(INPUT_DIR)/$(day).input | $(EMU) $(OUT_DIR)/$(day)$(part).rom

clean:
	@ rm -rf $(OUT_DIR)

build: $(OUT_DIR)/$(day)$(part).rom

grab: $(INPUT_DIR)/$(day).input

generate:
	@ mkdir -p $(SRC_DIR)/$(day)
	@ cp $(TEMPLATE) $(SRC_DIR)/$(day)/a.tal
	@ cp $(TEMPLATE) $(SRC_DIR)/$(day)/b.tal

