/* 
    This program is free software: you can redistribute it and/or modify 
    it under the terms of the GNU General Public License as published by 
    the Free Software Foundation, either version 3 of the License, or 
    (at your option) any later version. 
 
    This program is distributed in the hope that it will be useful, 
    but WITHOUT ANY WARRANTY; without even the implied warranty of 
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
    GNU General Public License for more details. 
 
    You should have received a copy of the GNU General Public License 
    along with this program.  If not, see <http://www.gnu.org/licenses/> 
*/

// local includes
#include "ArraySet.h"
#include "Tools.h"
#include "MemoryManager.h"
#include "GraphTools.h"
#include "Experiments.h"

// system includes
#include <map>
#include <list>
#include <string>
#include <vector>
#include <cassert>
#include <iostream>
#include <cstdlib>
#include <ctime>

using namespace std;

/*! \file main.cpp

    \brief Main entry point for the software. This is where we parse the command line options, read the inputs, and decide which clique method to run.

    \author Darren Strash (first name DOT last name AT gmail DOT com)

    \copyright Copyright (c) 2016 Darren Strash. This code is released under the GNU Public License (GPL) 3.0.

    \image html gplv3-127x51.png

    \htmlonly
    <center>
    <a href="gpl-3.0-standalone.html">See GPL 3.0 here</a>
    </center>
    \endhtmlonly
*/

void ProcessCommandLineArgs(int const argc, char** argv, map<string,string> &mapCommandLineArgs)
{
    for (int i = 1; i < argc; ++i) {
////        cout << "Processing argument " << i << endl;
        string const argument(argv[i]);
////        cout << "    Argument is " << argument << endl;
        size_t const positionOfEquals(argument.find_first_of("="));
////        cout << "    Position of = " << positionOfEquals << endl;
        if (positionOfEquals != string::npos) {
            string const key  (argument.substr(0,positionOfEquals));
            string const value(argument.substr(positionOfEquals+1));
////            cout << "    Parsed1: " << key << "=" << value << endl;
            mapCommandLineArgs[key] = value;
        } else {
////            cout << "    Parsed2: " << argument << endl;
            mapCommandLineArgs[argument] = "";
        }
    }
}

void PrintDebugWarning()
{
    cout << "\n\n\n\n\n" << flush;
    cout << "#########################################################################" << endl << flush;
    cout << "#                                                                       #" << endl << flush;
    cout << "#    WARNING: Debugging is turned on. Don't believe the run times...    #" << endl << flush;
    cout << "#                                                                       #" << endl << flush;
    cout << "#########################################################################" << endl << flush;
    cout << "\n\n\n\n\n" << flush;
}

void PrintNotes()
{
    cout << "NOTE: Kernel-MIS v1.0. Released under GNU GPLv3.0 license or (at your option) any later version of the GNU GPL license." << endl << flush;
    cout << "NOTE: " << endl << flush;
    cout << "NOTE: This is the code used in exeriments for:" << endl << flush;
    cout << "NOTE:     ``On the Power of Simple Reductions for the Maximum Independent Set Problem''" << endl << flush;
    cout << "NOTE: By Darren Strash" << endl << flush;
    cout << "NOTE: " << endl << flush;
    cout << "NOTE: Graphs are expected in METIS format." << endl << flush;
    cout << "NOTE: " << endl << flush;
    cout << "NOTE: If you find any problems, please e-mail Darren Strash at first DOT last AT gmail DOT com" << endl << flush;
}

string basename(string const &fileName)
{
    string sBaseName(fileName);

    size_t const lastSlash(sBaseName.find_last_of("/\\"));
    if (lastSlash != string::npos) {
        sBaseName = sBaseName.substr(lastSlash+1);
    }

    size_t const lastDot(sBaseName.find_last_of("."));
    if (lastDot != string::npos) {
        sBaseName = sBaseName.substr(0, lastDot);
    }

    return sBaseName;
}

static string programName;

void PrintUsageMessage() {
    cout << "USAGE: " << programName << " --input-file=<filename> [--latex] [--experiment=<experiment-name>] [--header]" << endl << flush;
    cout << "USAGE: " << endl << flush;
    cout << "USAGE: Where --input-file is in METIS format, with file name ending in .graph." << endl << flush;
    cout << "USAGE: " << endl << flush;
    cout << "USAGE: And --experiment is one of: " << endl << flush;
    cout << "USAGE: \tkernel-size" << endl << flush;
    cout << "USAGE: \tfast-kernel-size" << endl << flush;
    cout << "USAGE: \tcritical-independent-set" << endl << flush;
    cout << "USAGE: \tkernel-size-critical-set" << endl << flush;
    cout << "USAGE: \tkernel-size-maximum-critical-set" << endl << flush;
    cout << "USAGE: \tmcis" << endl << flush;
    cout << "USAGE: \tkernel-component-no-reduction-miss" << endl << flush;
}

void RunExperiment(string const &sInputFile, string const &sExperimentName, bool const bOutputLatex, bool const bPrintHeader, vector<vector<int>> const &adjacencyArray, vector<vector<char>> const &vAdjacencyMatrix, double const dTimeout)
{
    string const dataSetName(basename(sInputFile));
    Experiments experiments(dataSetName, dTimeout, bOutputLatex, bPrintHeader, adjacencyArray, vAdjacencyMatrix);

    if (sExperimentName=="kernel-size") {
        experiments.RunKernelSize();
    } else if (sExperimentName=="kernel-size-critical-set") {
        experiments.ComputeCriticalIndependentSetKernel();
    } else if (sExperimentName=="kernel-size-maximum-critical-set") {
        experiments.ComputeMaximumCriticalIndependentSetKernel();
    } else if (sExperimentName=="mcis") {
        experiments.ComputeMaximumCriticalIndependentSet();
    } else if (sExperimentName=="kernel-component-no-reduction-miss") {
        experiments.KernelizeAndRunComponentWiseMISS();
    } else {
        cout << "ERROR: Invalid experiment name: " << sExperimentName << endl << flush;
        PrintUsageMessage();
        exit(1);
    }
}


int main(int argc, char** argv)
{
    int failureCode(0);

    map<string,string> mapCommandLineArgs;

    ProcessCommandLineArgs(argc, argv, mapCommandLineArgs);

    bool   const bQuiet(mapCommandLineArgs.find("--verbose") == mapCommandLineArgs.end());
    bool   const bOutputLatex(mapCommandLineArgs.find("--latex") != mapCommandLineArgs.end());
    bool   const bOutputTable(mapCommandLineArgs.find("--table") != mapCommandLineArgs.end());
    string const inputFile((mapCommandLineArgs.find("--input-file") != mapCommandLineArgs.end()) ? mapCommandLineArgs["--input-file"] : "");
    string const sExperimentName((mapCommandLineArgs.find("--experiment") != mapCommandLineArgs.end()) ? mapCommandLineArgs["--experiment"] : "");
    bool   const bPrintHeader(mapCommandLineArgs.find("--header") != mapCommandLineArgs.end());
    string const sTimeout(mapCommandLineArgs.find("--timeout") != mapCommandLineArgs.end() ? mapCommandLineArgs["--timeout"] : "");
    bool   const bPrintHelp(mapCommandLineArgs.find("--help") != mapCommandLineArgs.end() || mapCommandLineArgs.find("-h") != mapCommandLineArgs.end());

    programName = argv[0];

    if (bPrintHelp) {
        PrintUsageMessage();
        return 0;
    }

    double dTimeout(0.0);
    if (!sTimeout.empty()) {
        try {
            dTimeout = stod(sTimeout);
        } catch(...) {
            cout << "ERROR: Invalid --timeout argument, please enter valid double value." << endl << flush;
        }
    }
    bool   const bRunExperiment(!sExperimentName.empty());

    bool   const bTableMode(bOutputLatex || bOutputTable);

    if (!bTableMode) {
        PrintNotes();
#ifdef DEBUG_MESSAGE
        PrintDebugWarning();
#endif //DEBUG_MESSAGE
    }

    bool bPrintUsageMessage(false);

    if (inputFile.empty()) {
        cout << "ERROR: Missing input file " << endl;
        bPrintUsageMessage = true;
    }

    if (!bRunExperiment) {
        cout << "ERROR: Missing experiment name." << endl;
        bPrintUsageMessage = true;
    }

    if (bPrintUsageMessage) {
        PrintUsageMessage();
        exit(1);
    }

    int n; // number of vertices
    int m; // 2x number of edges

    vector<list<int>> adjacencyList;
    if (inputFile.find(".graph") != string::npos) {
        if (!bTableMode) cout << "Reading .graph file format. " << endl << flush;
        adjacencyList = readInGraphAdjListEdgesPerLine(n, m, inputFile);
    } else {
        PrintUsageMessage();
        exit(1);
    }

    string const name(""); // TODO: get rid of vestigial code

    bool const bComputeAdjacencyMatrix(adjacencyList.size() < 20000);
    bool const bShouldComputeAdjacencyMatrix(name == "tomita" || name == "generic-adjmatrix" || name == "generic-adjmatrix-max" || name == "mcq" || name == "mcr" || name == "static-order-mcs" || name == "mcs" || name == "misq" || name == "reduction-misq" || name == "reduction-misr" || name == "reduction-static-order-miss" || name == "reduction-miss" || name == "misr" || name == "static-order-miss" || name == "miss" || name == "reduction-domination-misq" || name == "reduction-domination-misr" || name == "connected-component-miss" || name == "connected-component-miss2" /* || name == "comparison-miss"*/ || name == "tester-miss" || sExperimentName == "find-and-print-maxclique");

    bool const addDiagonals(bRunExperiment);

    if (bShouldComputeAdjacencyMatrix && !bComputeAdjacencyMatrix) {
        cout << "ERROR: unable to compute adjacencyMatrix, since the graph is too large: " << adjacencyList.size() << endl << flush;
        exit(1);
    }

    char** adjacencyMatrix(nullptr);

    vector<vector<char>> vAdjacencyMatrix;

    if (bComputeAdjacencyMatrix) {
        adjacencyMatrix = (char**)Calloc(n, sizeof(char*));
        vAdjacencyMatrix.resize(n);

        for(int i=0; i<n; i++) {
            adjacencyMatrix[i] = (char*)Calloc(n, sizeof(char));
            vAdjacencyMatrix[i].resize(n);
            for(int const neighbor : adjacencyList[i]) {
                adjacencyMatrix[i][neighbor]  = 1; 
                vAdjacencyMatrix[i][neighbor] = 1; 
            }
            if (addDiagonals) {
                adjacencyMatrix[i][i]  = 1;
                vAdjacencyMatrix[i][i] = 1;
            }
        }
    }

    bool const bComputeAdjacencyArray(bRunExperiment || name == "adjlist" || name == "timedelay-adjlist" || name == "generic-adjlist" || name == "generic-adjlist-max" ||name == "timedelay-maxdegree" || name == "timedelay-degeneracy" || name == "faster-degeneracy" || name == "generic-degeneracy" || name == "cache-degeneracy" || name == "mis" || name == "degeneracy-mis" || name == "partial-match-degeneracy" || name == "reverse-degeneracy" || name == "degeneracy-min" || name == "degeneracy-mis-2" || name == "reduction-mis" || name == "experimental-mis" || name == "reduction-misq" || name == "reduction-misr" || name == "reduction-static-order-miss" || name == "reduction-miss" || name == "reduction-sparse-misq" || name == "reduction-sparse-misr" || name == "reduction-sparse-static-order-miss" || name == "reduction-sparse-miss" || name == "reduction-domination-misq" || name == "reduction-domination-misr" || name == "sparse-mcq" || name == "sparse-mcr" || name == "sparse-static-order-mcs" || name == "sparse-mcs" || name == "connected-component-miss" || name == "connected-component-miss2"/* || name == "comparison-miss"*/ || name == "tester-miss");

    vector<vector<int>> adjacencyArray;

    if (bComputeAdjacencyArray) {
        adjacencyArray.resize(n);
        for (int i=0; i<n; i++) {
            adjacencyArray[i].resize(adjacencyList[i].size());
            int j = 0;
            for (int const neighbor : adjacencyList[i]) {
                adjacencyArray[i][j++] = neighbor;
            }
        }
        adjacencyList.clear(); // does this free up memory? probably some...
    }

    if (bRunExperiment) {
        RunExperiment(inputFile, sExperimentName, bOutputLatex, bPrintHeader, adjacencyArray, vAdjacencyMatrix, dTimeout);
        return 0;
    }

    if (adjacencyMatrix != nullptr) {
        int i = 0;
        while(i<n) {
            Free(adjacencyMatrix[i]);
            i++;
        }
        Free(adjacencyMatrix); 
        adjacencyMatrix = nullptr;
    }

#ifdef DEBUG_MESSAGE
    PrintDebugWarning();
#endif

    return 0;
}
