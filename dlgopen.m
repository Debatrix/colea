function [p,f] = dlgopen(cmd,ext)

%文件打开/保存
% Copyright (c) 1998 by Philipos C. Loizou
%


pos = get(0, 'screensize');
if (strcmp(cmd, 'open'))
  
  [f,p] = uigetfile(ext, 'COLEA'); %, pos(3)/2-150, pos(4)/2-200);
  if ((~isstr(f)) | ~min(size(f))), return; end		% Cancel
 

elseif (strcmp(cmd, 'save'))
 [f,p] = uiputfile(ext, 'COLEA'); %, pos(3)/2-150, pos(4)/2-200);
  if ((~isstr(f)) | ~min(size(f))), return; end		% Cancel
 
else
  error([' 未知命令 ''', cmd, '''.']);
end
