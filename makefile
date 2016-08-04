
BUILD_DIR = build
SRC_DIR   = src
BIN_DIR   = bin

CFLAGS = -Winline -O2 -std=c++0x -g
#CFLAGS = -Winline -DDEBUG_MESSAGE -O0 -std=c++0x -g

#SOURCES_TMP += LightWeightSparseFullMCS.cpp
#SOURCES_TMP += LightWeightSparseStaticOrderMCS.cpp
#SOURCES_TMP += LightWeightSparseMCR.cpp

SOURCES_TMP += Experiments.cpp
SOURCES_TMP += OrderingTools.cpp
SOURCES_TMP += MaxSubgraphAlgorithm.cpp
SOURCES_TMP += LightWeightFullMISS.cpp
SOURCES_TMP += LightWeightStaticOrderMISS.cpp
SOURCES_TMP += LightWeightMISR.cpp
SOURCES_TMP += LightWeightMISQ.cpp
SOURCES_TMP += SparseIndependentSetColoringStrategy.cpp
SOURCES_TMP += IndependentSetColoringStrategy.cpp
SOURCES_TMP += Isolates4.cpp
SOURCES_TMP += CliqueTools.cpp
SOURCES_TMP += MatchingTools.cpp
SOURCES_TMP += BiDoubleGraph.cpp
SOURCES_TMP += GraphTools.cpp
SOURCES_TMP += MemoryManager.cpp
SOURCES_TMP += Algorithm.cpp
SOURCES_TMP += Tools.cpp

SOURCES=$(addprefix $(SOURCES_DIR)/, $(SOURCES_TMP))

OBJECTS_TMP=$(SOURCES_TMP:.cpp=.o)
OBJECTS=$(addprefix $(BUILD_DIR)/, $(OBJECTS_TMP))

DEPFILES_TMP:=$(SOURCES_TMP:.cpp=.d)
DEPFILES=$(addprefix $(BUILD_DIR)/, $(DEPFILES_TMP))

EXEC_NAMES = kernel-mis

EXECS = $(addprefix $(BIN_DIR)/, $(EXEC_NAMES))

#DEFINE += -DDEBUG       #for debugging
#DEFINE += -DMEMORY_DEBUG #for memory debugging.
#DEFINE += -DRETURN_CLIQUES_ONE_BY_ONE 
#DEFINE += -DPRINT_CLIQUES_ONE_BY_ONE 

#DEFINE += -DPRINT_CLIQUES_TOMITA_STYLE # used by Eppstein and Strash (2011)

#some systems handle malloc and calloc with 0 bytes strangely.
DEFINE += -DALLOW_ALLOC_ZERO_BYTES# used by Eppstein and Strash (2011) 

VPATH = src

.PHONY : all

all: $(EXECS)

.PHONY : clean

clean: 
	rm -rf $(EXECS) $(BUILD_DIR) $(BIN_DIR)

$(BIN_DIR)/printnm: printnm.cpp ${OBJECTS} | ${BIN_DIR}
	g++ ${DEFINE} ${OBJECTS} $(SRC_DIR)/printnm.cpp -o $@

$(BIN_DIR)/kernel-mis: main.cpp ${OBJECTS} | ${BIN_DIR}
	g++ $(CFLAGS) ${DEFINE} ${OBJECTS} $(SRC_DIR)/main.cpp -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp $(SRC_DIR)/%.h $(BUILD_DIR)/%.d | $(BUILD_DIR)
	g++ $(CFLAGS) ${DEFINE} -c $< -o $@

$(BUILD_DIR)/%.d: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	g++ $(CFLAGS) -MM -MT '$(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$<)' $< -MF $@

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

