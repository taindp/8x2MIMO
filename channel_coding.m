function y=channel_coding(x_fix)
L_fix=ceil((length(x_fix)-16)/19);
x_pl=[];
x_cw=[];
for i=0:L_fix
    for j=0:15
         if strcmp(x_fix(19*i+j+1),'1')
             x_pl(16*i+j+1,1)=1;
         else x_pl(16*i+j+1,1)=0;
         end
    end
end
trellis = poly2trellis(7,[171 133]);
codedData = convenc(x_pl,trellis);
L_pl=length(x_pl);
for k=1:2*L_pl
    if(mod(k,2))
    x_cw(ceil(k/2),1)=codedData(k);
    else x_cw(k/2,2)=codedData(k);
    end
end
y=x_cw;

    