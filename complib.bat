@ECHO OFF
tasm %1
tasm libRands
tlink %1 libRands
%1