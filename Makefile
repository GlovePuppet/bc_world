export V ?= 0

OUTPUT_DIR := $(CURDIR)/out

.PHONY: all
all: bc prepare-for-rootfs

.PHONY: clean
clean: bc-clean prepare-for-rootfs-clean

bc:
	$(MAKE) -C host CROSS_COMPILE="$(HOST_CROSS_COMPILE)" || exit -1; \

examples-clean:
	$(MAKE) -C host clean || exit -1; \

prepare-for-rootfs: examples
	@echo "Copying example CA and TA binaries to $(OUTPUT_DIR)..."
	@mkdir -p $(OUTPUT_DIR)
	@mkdir -p $(OUTPUT_DIR)/ta
	@mkdir -p $(OUTPUT_DIR)/ca
	@for example in $(EXAMPLE_LIST); do \
		cp -p host/host/bc $(OUTPUT_DIR)/ca/; \
		cp -pr ta/*.ta $(OUTPUT_DIR)/ta/; \
	done

prepare-for-rootfs-clean:
	@rm -rf $(OUTPUT_DIR)/ta
	@rm -rf $(OUTPUT_DIR)/ca
	@rmdir --ignore-fail-on-non-empty $(OUTPUT_DIR) || test ! -e $(OUTPUT_DIR)