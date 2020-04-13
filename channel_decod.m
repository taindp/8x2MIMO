function y=channel_decod(y_cw0,y_cw1)
L=length(y_cw0);
a=[];
for i=0:L-1
    a(2*i+1,1)=y_cw0(i+1);
    a(2*i+2,1)=y_cw1(i+1);
end
trellis = poly2trellis(7,[171 133]);
y=vitdec(a,trellis,30,'trunc','hard');

