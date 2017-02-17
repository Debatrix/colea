function mclick

%  检测鼠标行为并进行适当操作
%

% Copyright (c) 1995 by Philipos C. Loizou
%

global fno Srate n_Secs AXISLOC h1T h2T S0 cAxes S1
global Be En TIME smspEc cAxes TWOFILES TOP Be2 En2
global Srate2 n_Secs2 tpc boc smp frq hl hr doit hll
global upFreq upFreq2 htop hbot lastClick hwi frst1 frst0
global doit0 doit1 SHOW_CRS SHOW_CHN posi

xv = get(fno,'CurrentPoint');  % get cursor coordinates in pixels
xp = xv(1);
yp = xv(2);


if TWOFILES==1
	set(fno,'Units','Normal');
	xv2 = get(fno,'CurrentPoint');
	set(fno,'Units','Pixels');
	if xv2(2)>0.5
	   TOP=1; 
	   set(tpc,'String',' ','BackGroundColor','y');
	   set(boc,'String',' ','BackGroundColor',[0 0 0]);
	else 
	   TOP=0; 
	   set(boc,'String',' ','BackGroundColor','y');
	   set(tpc,'String',' ','BackGroundColor',[0 0 0]);
	end
   if isempty(posi), posi=zeros(2,2); end;
end
	
typ = get(fno,'SelectionType');   % get mouse button (normal= left, 
				  % extend=middle, alt=right)


FigXY  = get(fno,'Position');

%
% 偏移量 Be 为了缩放而被加入账户？
%
if TWOFILES==1
  if TOP==1
  	Sample = Be2+round((xp-AXISLOC(1))*(En2-Be2)/AXISLOC(3));
	yoffs=0.55*FigXY(4);
	zhei =0.34*FigXY(4);
  	Freq   = round((yp-yoffs)*Srate2*0.5*upFreq2/zhei);
	stime = Sample*1000/Srate2;
	b= n_Secs2*Srate2;
  	hsra=0.5*Srate2;

	
  else
	Sample = Be+round((xp-AXISLOC(1))*(En-Be)/AXISLOC(3));
	yoffs=0.11*FigXY(4);
	zhei =0.34*FigXY(4);
  	Freq   = round((yp-yoffs)*Srate*0.5*upFreq/zhei);
	stime = Sample*1000/Srate;
	b= n_Secs*Srate;
  	hsra=0.5*Srate;
  end
  
else
  Sample = Be+round((xp-AXISLOC(1))*(En-Be)/AXISLOC(3));
  Freq   = round((yp-AXISLOC(2))*Srate*0.5*upFreq/AXISLOC(4));
  b= n_Secs*Srate;
  hsra=0.5*Srate;
  stime = Sample*1000/Srate;
end

%---- 检查光标线是否在显示区域内  -------

IN_WINDOW=0;
if TWOFILES==1 & TOP==1
 if ( Sample >= Be2 & Freq > 0.0 & Freq <= hsra & Sample < En2)
	if Sample < b
	 IN_WINDOW=1;
	end
 end
else
 if ( Sample >= Be & Freq > 0.0 & Freq <= hsra & Sample < En)
	if Sample < b
	 IN_WINDOW=1;
	end
 end
end

if  IN_WINDOW == 1

	
     tStr = sprintf('t= %d (ms)',round(stime));
     fStr = sprintf('f= %d Hz',Freq);

     top=FigXY(2)+100;
     left=FigXY(1)+10;

    
  %---------------- 绘制光标线 -------------------
   
   if SHOW_CRS==1
     if TWOFILES==0, axes(cAxes); end
	
	np=(Sample-Be)*1000/Srate;

	if TWOFILES==1
	 
	   if TOP==1
		lastClick=1;
		axes(htop);
	        Ylim=get(gca,'Ylim');
		np=(Sample-Be2)*1000/Srate2;
		
	   else
		lastClick=0; 
		axes(hbot);
		Ylim=get(gca,'Ylim');
	   end
	  if lastClick==1  & TOP==0, frst1=1; end;
	  if lastClick==0  & TOP==1, frst0=1; end;
	  if isempty(frst0), frst0=1; end;
	  if  isempty(frst1), frst1=1; end;
	else
    	 Ylim=get(gca,'YLim');
	end
    
    % ==== 左键 ===
     if (strcmp(typ,'normal')==1) 
	if TWOFILES==1
	  if TOP==1
	    if  doit1==1, posi(1,2)=En2; end;
	    S1=posi(1,2); posi(1,1)=Sample;
	  else
	    if doit0==1,  posi(2,2)=En; end;
	    S1=posi(2,2); posi(2,1)=Sample;
	  end
	end
	crsrline(np,Ylim,'left');  % 调用crsrline绘制光标线

    %===== 右键======
     elseif (strcmp(typ,'alt')==1) 
	if TWOFILES==1
	  if TOP==1
	    if  doit1==1,  posi(1,1)=Be2; end;
	    S0=posi(1,1);  posi(1,2)=Sample;
	  else
	    if doit0==1,  posi(2,1)=Be; end;
	    S0=posi(2,1); posi(2,2)=Sample;
	  end
	end
	crsrline(np,Ylim,'right'); 
	
     end   

  end
  %------------------结束光标线绘制------------ 
 
%-----------绘制样本点数与频率 -----
set(smp,'String',tStr,'ForegroundColor','w','BackgroundColor',[0 0 0]);

     if (TIME==0)
     	set(frq,'String',fStr,'ForegroundColor','w','BackgroundColor',[0 0 0]);
     end

    if (strcmp(typ,'normal')==1 | strcmp(typ,'extend')==1)
	     S0 = Sample;
	     if SHOW_CHN==1, pllpc(Sample); end;
	     if ~isempty(smspEc)
		if smspEc==1 
		 smspspec;
		end
	     end
	
    else %---- Right button was pressed (in SUN its middle)
	 S1 = Sample; 
    end
    

end

doit=0;





