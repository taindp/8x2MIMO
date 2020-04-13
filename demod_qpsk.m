function y=demod_qpsk(z)
s=size(z);
r=s(1);
c=s(2);
y_r=[];
y_rm=[];
y_rmpad=[];
y_dm1=[];
y_dm2=[];
i=0;
for m=1:r
   for n=1:c
       y_r(m,n)=round(z(m,n)*sqrt(2));
       if abs(y_r(m,n))~=0
           i=i+1;
           y_rm(m,i)=y_r(m,n);
       else i=i;
       end
   end
end
y_rmpad(1,:)=y_rm(1,1:length(y_rm)/2);
y_rmpad(2,:)=y_rm(2,length(y_rm)/2+1:length(y_rm));
y_rmpad=y_rmpad.*1/sqrt(2);
ss=size(y_rmpad);
cc=ss(2);
for k=1:cc
    if angle(y_rmpad(1,k))==pi/4;
            y_dm1(k,1)=0;
            y_dm1(k,2)=0;
    elseif angle(y_rmpad(1,k))==3*pi/4;
            y_dm1(k,1)=0;
            y_dm1(k,2)=1;
    elseif angle(y_rmpad(1,k))==-pi/4;
            y_dm1(k,1)=1;
            y_dm1(k,2)=0;
    else    y_dm1(k,1)=1;
            y_dm1(k,2)=1;
    end
end
for k=1:cc
    if angle(y_rmpad(2,k))==pi/4;
            y_dm2(k,1)=0;
            y_dm2(k,2)=0;
    elseif angle(y_rmpad(2,k))==3*pi/4;
            y_dm2(k,1)=0;
            y_dm2(k,2)=1;
    elseif angle(y_rmpad(2,k))==-pi/4;
            y_dm2(k,1)=1;
            y_dm2(k,2)=0;
    else    y_dm2(k,1)=1;
            y_dm2(k,2)=1;
    end
end
y=[y_dm1 y_dm2];