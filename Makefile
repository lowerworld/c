BUILD_ARTIFACT := a.out


################################################################################
# -D flags
################################################################################

### Log level
# 0: None
# 1: Error
# 2: Warning
# 3: Information
# 4: Enter/Leave
DEFINED_SYMBOLS += DBG_LOG_LEVEL=4

### Colorize log
DEFINED_SYMBOLS += ENABLE_DBG_LOG_COLOR


################################################################################
# -U flags
################################################################################
UNDEFINED_SYMBOLS += \


################################################################################
# -I flags
################################################################################
INCLUDE_PATHS += \
inc


################################################################################
# Other flags
################################################################################
OTHER_FLAGS += \
-std=c99 -O3 -Wall -fsigned-char


################################################################################
# -l flags
################################################################################
LIBRARIES += \


################################################################################
# -L flags
################################################################################
LIBRARY_SEARCH_PATHS += \


################################################################################
# Other object files
################################################################################
OTHER_OBJS += \


################################################################################
# Source directories
################################################################################
SUBDIRS := \
src


################################################################################
# Exclude Files
################################################################################
EXCLUDE_FILES := \


################################################################################
CC := gcc
RM := rm -fr

BUILD_DIR := .build

FLAGS := \
-c ${OTHER_FLAGS} -fmessage-length=0 \
$(addprefix -D,${DEFINED_SYMBOLS}) \
$(addprefix -U,${UNDEFINED_SYMBOLS}) \
$(addprefix -I",$(addsuffix ",${INCLUDE_PATHS}))

LIBS := \
$(addprefix -L",$(addsuffix ",${LIBRARY_SEARCH_PATHS})) \
$(addprefix -l,${LIBRARIES})

ifeq ($(strip ${SUBDIRS}),)
$(error SUBDIRS IS EMPTY)
endif

OBJS :=

define pwd
$(patsubst %/,%,$(dir $(word $(words ${MAKEFILE_LIST}),${MAKEFILE_LIST})))
endef

define generate-rule
FLAGS_$1 := \
$(addprefix -D,${DEFINED_SYMBOLS_LOCAL}) \
$(addprefix -U,${UNDEFINED_SYMBOLS_LOCAL}) \
$(addprefix -I",$(addsuffix ",${INCLUDE_PATHS_LOCAL})) \
${OTHER_FLAGS_LOCAL}

OBJS_$1 := $(addprefix ${BUILD_DIR}/,$(patsubst %.c,%.o,$(filter-out ${EXCLUDE_FILES},$(wildcard $(addsuffix /*.c,${SRCDIRS_LOCAL})))))
OBJS += $${OBJS_$1}

$${OBJS_$1}: ${BUILD_DIR}/%.o: %.c
	@echo 'Building file: $$<'
	${CC} $$(strip ${FLAGS} $${FLAGS_$1}) -MMD -MP -MF"$${@:.o=.d}" -MT"$${@:.o=.d}" -MT"$$@" -o"$$@" $$<
	@echo 'Finished building: $$<'
	@echo ''

DEFINED_SYMBOLS_LOCAL :=
UNDEFINED_SYMBOLS_LOCAL :=
INCLUDE_PATHS_LOCAL :=
OTHER_FLAGS_LOCAL :=
SRCDIRS_LOCAL :=
endef

ifneq ($(strip ${SUBDIRS}),)
include $(addsuffix /subdir.mk,$(sort ${SUBDIRS}))
endif

DEPS := ${OBJS:.o=.d}

ifneq (${MAKECMDGOALS},clean)
ifneq ($(strip ${DEPS}),)
-include ${DEPS}
endif
endif

.DEFAULT_GOAL := all

all: mkdirs ${BUILD_ARTIFACT}

mkdirs:
	$(shell SUBDIRS='${SUBDIRS}'; for SUBDIR in $${SUBDIRS}; do if [ ! -d ${BUILD_DIR}/$${SUBDIR} ]; then mkdir -p ${BUILD_DIR}/$${SUBDIR}; fi done)

${BUILD_ARTIFACT}: ${OBJS} ${OTHER_OBJS}
	@echo 'Building target: $@'
	${CC} -o $@ $(strip ${OBJS} ${OTHER_OBJS} ${LIBS})
	@echo 'Finished building target: $@'
	@echo ''

clean:
	-${RM} ${BUILD_DIR}/ ${BUILD_ARTIFACT}
	-@echo ''

.PHONY: all clean mkdirs
