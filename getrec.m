function getrec

% Copyright (c) 1995 Philipos C. Loizou
%

fp= fopen('sndcard.cfg','r');

if fp<0
  errordlg('�Ҳ������������ļ���sndcard.cfg��������ļ������ڣ�����������������¼Ӧ�ó��������','GETREC');
else
 
 snd = fscanf(fp,'%s');
 fclose(fp);

 if ~isempty(snd) 
    exe=['!' snd];
    eval(exe); 
 else
  str=sprintf('δ�ҵ���¼����: %s',snd);
  errordlg(str,'GETREC');
 end

end

