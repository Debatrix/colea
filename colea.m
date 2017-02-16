function colea(infile,Srate1)

% COLEA������
% ������� 
% ���Ƴ���������
% ���������д�




colordef none  % ��MATLAB 4.x��ע�͵����У����û��4.x�ˣ�

global hl hr doit
global fed shW
global filename
global fno Srate n_Secs filename AXISLOC  nLPC HDRSIZE
global nChannels fftSize filterWeights UpperFreq LowFreq ChanpUp
global center LPCSpec SpecUp Dur DurUp filterA filterB  S1 S0
global HDRSIZE cAxes En Be TIME centSMSP Asmsp Bsmsp OVRL WAV1 CLR
global TWOFILES wav agcsc MAX_AM upFreq upFreq2 FIX_SCALE
global SHOW_CRS SHOW_CHN ftype ftype2 bpsa bpsa2 PREEMPH LPC_ONLY
global lpcParam fft_par NAR_BAND SPEC_EXP FILT_TYPE VOL_MAX
global VOL_NORM
global sli n_samples FFT_SET XFFT
global tpc boc
global smp frq TOP
global preUp  defUp w64Up w128Up w256Up w512Up narUp
global crsUp chnUp lpcUp chnlpUp fbrd fnar
global ovlpfilt SET_X_AXIS LD_LABELS



%���������ļ������ڻ����
if (nargin < 1)
 [pth,fname] = dlgopen('open','*.ils;*.wav');
 if ((~isstr(fname)) | ~min(size(fname))), return; end  
 filename=[pth,fname];
else
  filename=infile;
end
pos = get(0, 'screensize'); % ��ȡ��ʾ���ߴ�
sWi = pos(3);
sHe = pos(4);
%����Ĭ�ϴ��ڴ�С
WIDTH   =round(0.9375*sWi);
HEIGHT  =round(0.43*sHe) ;
LEFT    =round(0.025*sWi);
BOTTOM  =round(sHe-HEIGHT-40);
%����Ĭ������
LPCSpec = 1;            % if 0 display FFT, else LPC spectrum
TIME=1;                 % if 0 display spectrogram, else time waveform
WAV1=0;                 % If 1, then it is a .wav file with 8 bits/sample
CLR=1;                  % If 1 display spectrogram in color, else in gray scale
TWOFILES=0;             % If 1, then display two files
wav(1)=0; wav(2)=0;     % Used in case of dual-displays for 1-byte samples, as in WAV
upFreq=1.0;             % Upper frequency (percentage of Srate/2) in spectrogram
upFreq2=1.0;            % Upper frequency in spectrogram (1.0=Srate/2)
FIX_SCALE=-1;           % if > 0, then channel y-axis is always 0-15 dB
SHOW_CRS=1;             % if 1, show cursor lines, else dont
SHOW_CHN=1;             % if 1, show channel output/LPC display
PREEMPH=1;              % if 1, do pre-emphasis when computing the  spectrogram
LPC_ONLY=1;             % if 1, only the LPC specrtrum is displayed
lpcParam(1)=1;          % if 1, use hamming window in LPC analysis, else use rectangular 
lpcParam(2)=0;          % if 1, first-order pre-emphasis in LPC analysis, else dont
			% NOTE: this pre-emphasis is done in addition to the CIS pre-emphasis
lpcParam(3)=-1;         % if 1, enhance spectral peaks in LPC analysis
fft_par(1)=1;           % if 1, use lines when plotting FFT, else use pickets
fft_par(2)=1;           % if 1 use hamming window, else rectangular
NAR_BAND=0;             % if 1, display narrowband spectrograms
SPEC_EXP=0.25;		% Used in spectrogram display (root compression)
FILT_TYPE='broad';	% the filter type
VOL_MAX=0;		% used for controling the volume
VOL_NORM=1;		% if 1, then volume is normalized
FFT_SET=0;		% if 1, use user defined FFT size
XFFT=0;			% same as above
SET_X_AXIS=0;
ovlpfilt=0;
LD_LABELS=0;
TOP=0;
%�ļ���
fp = fopen(filename,'r');

if fp <=0
	disp('�����ļ�δ�ҵ�..')
	return;
end

ftype='short'; bpsa=2;    % ÿ���������bytes
ftype2='short'; bpsa2=1;
%��ȡ��չ��
ind1=find(filename == '.');
if length(ind1)>1, ind=ind1(length(ind1)); else, ind=ind1; end;
ext = lower(filename(ind+1:length(filename))); 



%��ȡ�ļ�ͷ��Ϣ
[HDRSIZE, xSrate, bpsa, ftype] =  gethdr(fp,ext);

%��ȡ��Ƶ����
if xSrate==0, return; 
else Srate=xSrate; end;

if strcmp(ftype,'ascii')
 x=fscanf(fp,'%f',inf);
else
 x  = fread(fp,inf,ftype);
end
%xӦ���ǲ����� Srate�ǲ�����
	


fclose(fp); 
%����Ĭ�ϲ�����
if Srate<6000 | Srate>45000 & nargin<2
h=warndlg('�����ʲ��ڷ�Χ��: 10,000 < F < 45,000 . �����õ�  10,000 Hz.','����!');
  disp('����! �����ʲ��ڷ�Χ��: 6,000 < F < 45,000');
  disp('...����Ĭ��ֵΪ 10,000 Hz.');
  Srate=10000;
end    


%����ֱ������
x= x - mean(x);  

if (nargin==2)
 Srate  = str2num(Srate1);
 if Srate<10000 | Srate>45000
	error('ָ���Ĳ���Ƶ����Ч: 10,000<F<45,000');
 end
end

MAX_AM=2048; % ������12λ�ֱ���

mx=max(x);
agcsc=MAX_AM/mx;


n_samples = length(x);%��������
n_Secs    = n_samples/Srate;%��Ƶʱ��
Dur=10.0;   % ʱ�䴰�����룩
S1=n_samples;
S0=0;
Be=S0;
En=S1;
OVRL=1;  % if 1 then hold off plots, else hold on plots in 'pllpc'

fprintf('������: %d Hz,  ��������: %d (%4.2f ��)\n',Srate,n_samples,n_Secs);
%���ƴ���
fno =  figure('Units', 'Pixels', 'Position', [LEFT BOTTOM WIDTH HEIGHT],...
	'WindowButtonDownFcn','mclick',...
	'Resize','on','Name',filename,'NumberTitle','Off',...
	'Menubar','None','WindowButtonMotionFcn','showpt',...
	'KeyPressFcn','getkb','Color','k');
		       
%------------ ȷ��������ߴ� ------------
%������
le=round(0.2*WIDTH);
bo=round(0.174*HEIGHT);
wi=round(0.773*WIDTH);
he=round(0.739*HEIGHT);

AXISLOC = [le bo wi he];
cAxes = axes('Units','Pixels','Position',AXISLOC);


axes(cAxes);



	Et=1000*n_samples/Srate;
	xax=0:1000/Srate:(Et-1000/Srate);
	
	plot(xax,x,'y')
	xlabel('ʱ�� (msecs)');
	ylabel('���');
	set(gca,'Color','k'); set(gca,'Xcolor','w'); set(gca,'YColor','w');
	%set(gca,'Units','points','FontSize',9);
	if min(x)<-1000 | mx >1000
	  axis([0 Et min(x)-200 max(x)+200]);
	else
	  axis([0 Et min(x) max(x)]);
	end
            
   %set(gca,'Color','k');
   set(gca,'XColor','w');
   set(gca,'YColor','w');
xywh = get(fno, 'Position'); %��õ�ǰ���λ��
axi=AXISLOC;

% Buttons.
left = 10;
wide = 80;
top  = xywh(4) - 10;
high = 22;
high=22;
if 9*(22+8) > xywh(4), high=17; end;
inc  = high + 8;
%---------- ��ʾ�������밴ť-------------
sli = uicontrol('Style','slider','min',0,'max',1000','Callback',...
	'getslide','Position',[axi(1) axi(2)+axi(4)+2 axi(3) 12]);
%getslide ����ͼ�Ϸ�������


%zoomi  �Ŵ�ť����С��ť
Zin = uicontrol('Style', 'PushButton', 'Callback','zoomi(''in'')', ...
	 'HorizontalAlign','center', 'String', '��С',...
	 'Position', [left top-high wide high]);

top = top - inc;
Zout = uicontrol('Style', 'PushButton', 'Callback','zoomi(''out'')', ...
	 'HorizontalAlign','center', 'String', '�Ŵ�',...
	 'Position', [left top-high wide high]);
if Srate>12000
  nLPC=14;
else
 nLPC=12; % ��ʼ��LPC����
end
top = top - inc-20;
uicontrol('Style','Frame','Position',[left top-high-10 wide+5 high+30],...
	'BackgroundColor','b');
 
uicontrol('Style','text','Position',[left+wide/3 top 40 high-3],'BackGroundColor','b',...
	'HorizontalAlignment','left','ForeGroundColor','w','String','����');

plUp = uicontrol('Style', 'PushButton', 'Callback', 'playf(''all'')', ...
	  'HorizontalAlign','center', 'String', 'ȫ��',...
	  'Position', [left top-high wide/2 high]);

uicontrol('Style', 'PushButton', 'Callback', 'playf(''sel'')', ...
	  'HorizontalAlign','center', 'String', '��ʾȫ��',...
	  'Position', [left+wide/2+5 top-high wide/2 high]);
%playf ���Ű�ť��
  
%---Draw the squares in case its TWOFILES
wwi=xywh(3); whe=xywh(4);%������λ��
tpc=uicontrol('Style','text','Position',[wwi-10 2*whe/3+10 10 10],'String',' ','BackGroundColor',[0 0 0]);
boc=uicontrol('Style','text','Position',[wwi-10 whe/3-10 10 10],'String',' ','BackGroundColor',[0 0 0]);


%----Draw the time and freq numbers----------
smp=uicontrol('Style','text','Position',[10 30 wide+10 15],'BackGroundColor',[0 0 0],...
	'HorizontalAlignment','left');
frq=uicontrol('Style','text','Position',[10 10 wide+10 15],'BackGroundColor',[0 0 0],...
	'HorizontalAlignment','left');


%
%-------------------------MENUS---------------------------------�Բ�������벻��ȥ��
%
ff=uimenu('Label','�ļ�');
   uimenu(ff,'Label','����','Callback','loadfile(''stack'')');
   uimenu(ff,'Label','���벢���','Callback','loadfile(''replace'')');
   uimenu(ff,'Label','���������ļ�','Callback','savefile(''whole'')','Separator','on');
   uimenu(ff,'Label','����ѡ�е�����','Callback','savefile(''seg'')');
   uimenu(ff,'Label','�ڹ�괦�����ļ�','CallBack','editool(''insfile'')','Separator','on');
   uimenu(ff,'Label','�ļ�Ӧ��','Callback','filetool');
   uimenu(ff,'Label','����ͼ��','Callback','cprint(''landscape'',''printer'')','Separator','on');
   uimenu(ff,'Label','����ģ��','Callback','cprint(''portrait'',''printer'')');
   fprf=uimenu(ff,'Label','���Ƶ��ļ� ...');
	uimenu(fprf,'Label','Postscript','Callback','cprint(''landscape'',''eps'')');
	uimenu(fprf,'Label','Windows metafile','Callback','cprint(''landscape'',''meta'')');


   uimenu(ff,'Label','�˳�','CallBack','quitall','Separator','on');

fed=uimenu('Label','�༭');
    uimenu(fed,'Label','����','CallBack','editool(''cut'')');
    uimenu(fed,'Label','����','CallBack','editool(''copy'')');
    uimenu(fed,'Label','ճ��','CallBack','editool(''paste'')');
    uimenu(fed,'Label','���','CallBack','modify(''zero'')','Separator','on');
    fm2=uimenu(fed,'Label','�Ŵ�/˥����');        
	uimenu(fm2,'Label','X2','CallBack','modify(''multi2'')');       
	uimenu(fm2,'Label','X0.5','CallBack','modify(''multi05'')');
     uimenu(fed,'Label','�ڹ�괦���뾲����','CallBack','iadsil');

    
    

fd=uimenu('Label','��ͼ');
	uimenu(fd,'Label','ʱ�䲨��','Callback','setdisp(''time'')');
       fd0= uimenu(fd,'Label','����ͼ');
	uimenu(fd0,'Callback','setdisp(''spec'',''clr'')',...
	    'Label','��ɫ');
	uimenu(fd0,'Callback','setdisp(''spec'',''noclr'')',...
	    'Label','�Ҷ�');
	uimenu(fd0,'Callback','setdisp(''spec'',''4khz'')',...
	    'Label','0-4 kHz');
	uimenu(fd0,'Callback','setdisp(''spec'',''5khz'')',...
	    'Label','0-5 kHz');
	uimenu(fd0,'Callback','setdisp(''spec'',''full'')',...
	    'Label','�����: 0-fs/2');
	fd01=uimenu(fd0,'Label','��ѡ��');
	    preUp=uimenu(fd01,'Label','Ԥ����','Checked','on',...
		   'Callback','prefer(''preemp'')');
	    fd02=uimenu(fd01,'Label','����');
		defUp=uimenu(fd02,'Label','Ĭ��','Checked','on',...
		   'Callback','prefer(''win_default'')');
		w64Up=uimenu(fd02,'Label','64 pts','Checked','off',...
		   'Callback','prefer(''win_64'')');
		w128Up=uimenu(fd02,'Label','128 pts','Checked','off',...
		   'Callback','prefer(''win_128'')');
		w256Up=uimenu(fd02,'Label','256 pts','Checked','off',...
		   'Callback','prefer(''win_256'')');
		w512Up=uimenu(fd02,'Label','512 pts','Checked','off',...
		   'Callback','prefer(''win_512'')');

	   fd03=uimenu(fd01,'Label','����֡��С');
		uimenu(fd03,'Label','Ĭ��','Callback','prefer(''upd_default'')');
		uimenu(fd03,'Label','8 pts','Callback','prefer(''upd_8'')');
		uimenu(fd03,'Label','16 pts','Callback','prefer(''upd_16'')');
		uimenu(fd03,'Label','32 pts','Callback','prefer(''upd_32'')');
		uimenu(fd03,'Label','64 pts','Callback','prefer(''upd_64'')');
	
	 fd04=uimenu(fd01,'Label','�������ǿ');
		uimenu(fd04,'Label','Ĭ��','Callback','prefer(''enh_default'')');
		uimenu(fd04,'Label','0.3','Callback','prefer(''enh_3'')');
		uimenu(fd04,'Label','0.4','Callback','prefer(''enh_4'')');
		uimenu(fd04,'Label','0.5','Callback','prefer(''enh_5'')');
		uimenu(fd04,'Label','0.6','Callback','prefer(''enh_6'')');

	
	uimenu(fd,'Label','������','Callback','setdisp(''single'')');
   
   
	uimenu(fd,'Label','����ͼ','Callback','engy');
	fdf0=uimenu(fd,'Label','F0 ����');
	     uimenu(fdf0,'Label','����ط���','Callback','estf0(''autocor'')');
	     uimenu(fdf0,'Label','���׷���','Callback','estf0(''cepstrum'')');
		uimenu(fd,'Label','�����켣','Callback','ftrack(''plot'')');
	uimenu(fd,'Label','�������ܶ�','Callback','estpsd');
	fd2=uimenu(fd,'Label','��ѡ��');
	    crsUp=uimenu(fd2,'Label','  ��ʾ�����','Checked','on',...
		   'Callback','prefer(''crs'')');
	    

	
		
fv1=uimenu('Label','��¼','CallBack','getrec');
fm1=uimenu('Label','����');
    
                        
    uimenu(fm1,'Label','��Ӹ�˹����..','CallBack','isnr(''gaussian'')');
    uimenu(fm1,'Label','���ļ��������..','CallBack','isnr(''spec'')');
    fm3=uimenu(fm1,'Label','ת��Ϊ SCN ����','Callback','modify(''scn'')'); 
    uimenu(fm1,'Label','������','Callback','filtool','Separator','on');
    uimenu(fm1,'Label','���Ҳ�������','Callback','sintool');
    uimenu(fm1,'Label','��ǩ����','Callback','labtool'); 
    uimenu(fm1,'Label','�ȽϹ���','Callback','distool');
    uimenu(fm1,'Label','��������','Callback','voltool');

uimenu('Label','����','Callback','helpf(''colea'')');
%���ٵ����ﶼ���ڻ��ƿؼ�
%----------- ��ʼ������߾�� ------------

np=3; Ylim=get(gca,'YLim');
hl=line('Xdata',[np np],'Ydata',Ylim,'Linestyle','-',...
	   'color',[0 0 0],'Erasemode','xor');

hr=line('Xdata',[np np],'Ydata',Ylim,'Linestyle','--',...
	   'color',[0 0 0],'Erasemode','xor');
doit=0;




