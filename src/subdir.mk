CURRENT_DIR := $(pwd)

################################################################################
# -D flags
################################################################################
DEFINED_SYMBOLS_LOCAL += \


################################################################################
# -U flags
################################################################################
UNDEFINED_SYMBOLS_LOCAL += \


################################################################################
# -I flags
################################################################################
INCLUDE_PATHS_LOCAL += \


################################################################################
# Other flags
################################################################################
OTHER_FLAGS_LOCAL += \


################################################################################
# Source directories
################################################################################
SRCDIRS_LOCAL := \
${CURRENT_DIR}


################################################################################
# Exclude Files
################################################################################
EXCLUDE_FILES += \


################################################################################
$(eval $(call generate-rule,src))