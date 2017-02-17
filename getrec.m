function getrec

% Copyright (c) 1995 Philipos C. Loizou
%

fp= fopen('sndcard.cfg','r');

if fp<0
  errordlg('找不到声卡配置文件：sndcard.cfg。如果此文件不存在，则它将被创建并记录应用程序的名称','GETREC');
else
 
 snd = fscanf(fp,'%s');
 fclose(fp);

 if ~isempty(snd) 
    exe=['!' snd];
    eval(exe); 
 else
  str=sprintf('未找到记录功能: %s',snd);
  errordlg(str,'GETREC');
 end

end

