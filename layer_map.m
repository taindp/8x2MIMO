function y=layer_map(cw0,cw1)
L=length(cw0);
layer=[];
% for i=1:L
%     if(mod(i,2))
%         layer(ceil(i/2),2)=cw0(i);
%         layer(ceil(i/2),4)=cw1(i);
%     else
%         layer(i/2,1)=cw0(i);
%         layer(i/2,3)=cw1(i);
%     end
% end
layer(1,:)=cw0;
layer(2,:)=cw1;
y=layer;