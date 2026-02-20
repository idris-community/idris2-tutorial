# ===============================================================================
# Variables
# ===============================================================================
IPKG := tutorial.ipkg
SRC_DIR := src
BUILD_DIR := build
TTC_DIR := $(BUILD_DIR)/ttc
TEMP_DIR := $(BUILD_DIR)/tmp
BOOK_DIR := book
TTC_NUMBER := $(shell idris2 --ttc-version)


# ==============================================================================
# Modules
# ==============================================================================
MODULES := $(shell idris2 --dump-ipkg-json $(IPKG) | jq -r '.modules[]')
MODULE_PATHS := $(subst .,/,$(MODULES))

SRC_MD := $(shell find $(SRC_DIR) -type f -name '*.md' -printf "%P\n")
SRC_IDR := $(shell find $(SRC_DIR) -type f -name '*.idr' -printf "%P\n")

# Literate Idris files
LIT_PATHS := $(filter $(SRC_MD), $(addsuffix .md, $(MODULE_PATHS)))

# Plain Markdown files
MD_PATHS := $(filter-out $(LIT_PATHS), $(SRC_MD))

# TTC build stamp
TTC_STAMP := $(TTC_DIR)/$(TTC_NUMBER)/.built

.PHONY: all build copy-md katla-md katla-idr book clean

all: book

# ===============================================================================
# Build
# ===============================================================================
$(TTC_STAMP): $(addprefix src/, $(SRC_IDR)) $(addprefix src/,$(SRC_MD)) | $(TTC_DIR)/$(TTC_NUMBER)
	@echo "Building all TTC files..."
	pack build
	@touch $@

$(TTC_DIR)/$(TTC_NUMBER):
	@mkdir -p $@

build: $(TTC_STAMP)

# ===============================================================================
# Temporary directory
# ===============================================================================
$(TEMP_DIR): $(TTC_STAMP)
	@mkdir -p $@

# ===============================================================================
# Copy plain Markdown files
# ===============================================================================
$(patsubst %.md,$(TEMP_DIR)/src/%.md,$(MD_PATHS)): $(TEMP_DIR)/src/%.md : $(SRC_DIR)/%.md $(TTC_STAMP) | $(TEMP_DIR)
	@mkdir -p $(dir $@)
	cp $< $@

copy-md: $(patsubst %.md,$(TEMP_DIR)/src/%.md,$(MD_PATHS))

# ===============================================================================
# Highlight literate Markdown files
# ===============================================================================
$(patsubst %.md,$(TEMP_DIR)/src/%.md,$(LIT_PATHS)): $(TEMP_DIR)/src/%.md : $(SRC_DIR)/%.md $(TTC_STAMP) | $(TEMP_DIR)
	@mkdir -p $(dir $@)
	katla markdown $< $(TTC_DIR)/$(TTC_NUMBER)/$*.ttm > $@
	sed -Ezi -f scripts/process-katla.sed $@

katla-md: $(patsubst %.md,$(TEMP_DIR)/src/%.md,$(LIT_PATHS))

# ===============================================================================
# Highlight Idris files
# ===============================================================================
$(patsubst %.idr,$(TEMP_DIR)/src/%.md,$(SRC_IDR)): $(TEMP_DIR)/src/%.md : $(SRC_DIR)/%.idr $(TTC_STAMP) | $(TEMP_DIR)
	@mkdir -p $(dir $@)
	katla html $< $(TTC_DIR)/$(TTC_NUMBER)/$*.ttm > $@
	sed -Ezi -f scripts/process-katla.sed -f scripts/remove-line-numbers.sed $@

katla-idr: $(patsubst %.idr,$(TEMP_DIR)/src/%.md,$(SRC_IDR))

# ===============================================================================
# Build the book
# ===============================================================================
book: copy-md katla-md katla-idr | $(TEMP_DIR)
	cp book.toml $(TEMP_DIR)/book.toml
	@echo "Building the book..."
	cd $(TEMP_DIR) && mdbook build
	rm -rf $(BOOK_DIR)
	cp -r $(TEMP_DIR)/book $(BOOK_DIR)

# ===============================================================================
# Clean
# ===============================================================================
clean:
	pack clean
	rm -rf $(TEMP_DIR) $(BOOK_DIR) $(TTC_DIR)
