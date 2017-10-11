function positiveFFT(x,Fs)

%0.5to4 Hz filter 176 orders. Removes data beyond 3Hz.
filter1=[-2.67279454822601e-09;
    -4.94948708621276e-09;-3.71218548979511e-09;-1.31355602046262e-09;3.02679071520881e-09;1.10080040327531e-08;2.58186696723760e-08;5.27812168330374e-08;9.99294051855821e-08;1.78279737634846e-07;3.01453779497482e-07;4.84225731895041e-07;7.39544904819438e-07;1.07366090980974e-06;1.47920379745965e-06;1.92647505335795e-06;2.35379330712033e-06;2.65847687008325e-06;2.69084371234455e-06;2.25432161233988e-06;1.11518409916840e-06;-9.74673547383517e-07;-4.23936343916052e-06;-8.82428353423543e-06;-1.47270952766590e-05;-2.17201570900467e-05;-2.92744481526792e-05;-3.64992889352170e-05;-4.21156258149846e-05;-4.44823289223750e-05;-4.16938507946713e-05;-3.17628399093753e-05;-1.28923726567872e-05;1.61706088574744e-05;5.57255194694438e-05;0.000104695102165964;0.000160249786094756;0.000217553838743617;0.000269714253131432;0.000308009283475485;0.000322456347492207;0.000302747389944752;0.000239534411884863;0.000125991708874539;-4.04801010820302e-05;-0.000256602219327286;-0.000511859207365945;-0.000787700715882322;-0.00105756487147495;-0.00128794174293950;-0.00144061154229400;-0.00147606988218525;-0.00135799959173868;-0.00105847936768250;-0.000563453194293824;0.000122156197075096;0.000970397745038759;0.00192803429342566;0.00291673722518808;0.00383623171495378;0.00457063693355373;0.00499791602428291;0.00500197370587036;0.00448655355945609;0.00338973799089598;0.00169758913314017;-0.000544667603818816;-0.00322549002841281;-0.00616526202080312;-0.00912091280984488;-0.0117973492104499;-0.0138654803852036;-0.0149859062144449;-0.0148366546591211;-0.0131427693860507;-0.00970514064076992;-0.00442580031921116;0.00267299527777098;0.0114381843818755;0.0215854593823622;0.0327097448175030;0.0443063781357198;0.0558017503528035;0.0665912090348113;0.0760812472711171;0.0837324876430841;0.0890997820612502;0.0918659155374315;0.0918659155374315;0.0890997820612502;0.0837324876430841;0.0760812472711171;0.0665912090348113;0.0558017503528035;0.0443063781357198;0.0327097448175030;0.0215854593823622;0.0114381843818755;0.00267299527777098;-0.00442580031921116;-0.00970514064076992;-0.0131427693860507;-0.0148366546591211;-0.0149859062144449;-0.0138654803852036;-0.0117973492104499;-0.00912091280984488;-0.00616526202080312;-0.00322549002841281;-0.000544667603818816;0.00169758913314017;0.00338973799089598;0.00448655355945609;0.00500197370587036;0.00499791602428291;0.00457063693355373;0.00383623171495378;0.00291673722518808;0.00192803429342566;0.000970397745038759;0.000122156197075096;-0.000563453194293824;-0.00105847936768250;-0.00135799959173868;-0.00147606988218525;-0.00144061154229400;-0.00128794174293950;-0.00105756487147495;-0.000787700715882322;-0.000511859207365945;-0.000256602219327286;-4.04801010820302e-05;0.000125991708874539;0.000239534411884863;0.000302747389944752;0.000322456347492207;0.000308009283475485;0.000269714253131432;0.000217553838743617;0.000160249786094756;0.000104695102165964;5.57255194694438e-05;1.61706088574744e-05;-1.28923726567872e-05;-3.17628399093753e-05;-4.16938507946713e-05;-4.44823289223750e-05;-4.21156258149846e-05;-3.64992889352170e-05;-2.92744481526792e-05;-2.17201570900467e-05;-1.47270952766590e-05;-8.82428353423543e-06;-4.23936343916052e-06;-9.74673547383517e-07;1.11518409916840e-06;2.25432161233988e-06;2.69084371234455e-06;2.65847687008325e-06;2.35379330712033e-06;1.92647505335795e-06;1.47920379745965e-06;1.07366090980974e-06;7.39544904819438e-07;4.84225731895041e-07;3.01453779497482e-07;1.78279737634846e-07;9.99294051855821e-08;5.27812168330374e-08;2.58186696723760e-08;1.10080040327531e-08;3.02679071520881e-09;-1.31355602046262e-09;-3.71218548979511e-09;-4.94948708621276e-09;-2.67279454822601e-09];

%transposes the values for easier manipulation
filter1=filter1.';
x=filter(filter1,1,x);

N=length(x); %get the number of points
k=0:N-1;     %create a vector from 0 to N-1
T=N/Fs;      %get the frequency interval
freq=k/T;    %create the frequency range
X=fft(x-mean(x))/N; % normalization and subtracts the DC magnetic field

%gets the positive half of the FFT
cut = ceil(N/2);
X = X(1:cut);
freq = freq(1:cut);
figure(1)
%ouputs the FFT graph
plot(freq,abs(X))
xlabel('frequency')
ylabel('amplitude')
title('FFT with shift and normalization')
grid

%creates a 2d matrix
array1=[freq;abs(X)];
array1=array1.';
length(array1);
array2=[];
j=1;

%finds the first harmonic frequency location
maxval=array1(1,2);
maxfreq=array1(1,1);
for i=2:size(array1)
    if maxval <=array1(i,2)
        maxval=array1(i,2);
        maxfreq=array1(i,1);
    end
end

%reduces the array to after 1hz to find the second harmonics
for i=1:size(array1)
    if array1(i,1)>1
        secondharm = i;
        break
    end
end

%finds the location of second harmonic location
maxval2=array1(secondharm,2);
maxfreq2=array1(secondharm,1);
for i= secondharm:((size(array1))/2)
    if  maxval2 <=array1(i,2)
        maxval2=array1(i,2);
        maxfreq2=array1(i,1);
    end
end

%removes all the data with less than 0.5 amplitude 
for i=1:size(array1)
    if array1(i,2) >=0.5
        array2(j,1)=array1(i,1);
        array2(j,2)=array1(i,2);
        j=j+1;
    end
end

%takes the mean of the spectrum
meanvalue=mean(array2(:,2));

%distinguishes amplitude values that are above mean
k=1;
array3=[];
for i=1:size(array2)
    if array2(i,2)>=meanvalue
        array3(k,1)=array2(i,1);
        array3(k,2)=array2(i,2);
        k=k+1;
    end
end

%removes duplicates that are within 0.3 frequency range between i and i+1. 
array3(end+1,1)=0;
l=1;
outputarray=[];
for i=1:size(array3)-1
    if abs((array3(i,1)-array3(i+1,1)))<0.3
        if (array3(i,2)>= array3(i+1,2))
            outputarray(l,1)=array3(i,1);
            outputarray(l,2)=array3(i,2);
        else
            outputarray(l,1)=array3(i+1,1);
            outputarray(l,2)=array3(i+1,2);
        end
        l=l+1;
    end
end

%check1 = checks the first harmonics located between maxfreq +/- 0.1 (first
%harmonics)
%check2 = checks the second harmonics located between maxfreq2 +/- 0.1
%(second harmonics)

%these values are specific to circuits
check1=0;
check2=0;

for i=1:size(outputarray)
    if (outputarray(i,1)>=(maxfreq-0.1) && outputarray(i,1)<=(maxfreq+0.1))
        check1=1;
    end
    if (outputarray(i,1)>=(maxfreq2-0.1) && outputarray(i,1)<=(maxfreq2+0.1))
        check2=1;
    end
end

%further duplicate removal but not used for now.
%outputarray(end+1,1)=0;
%outputarray1=[];
%h=0;
%for i=1:size(outputarray)-1
%    if abs((outputarray(i,1)-outputarray(i+1,1)))<0.3
%        if (outputarray(i,2)>= outputarray(i+1,2))
%            outputarray1(h,1)=outputarray(i,1);
%            outputarray1(h,2)=outputarray(i,2);
%        else
%            outputarray1(h,1)=outputarray(i+1,1);
%            outputarray1(h,2)=outputarray(i+1,2);
%        end
%        h=h+1;
%    end
%end


%plot above mean         
figure(2)
stem(array3(:,1),array3(:,2))
xlabel('frequency')
ylabel('amplitude')
title('FFT above mean')
grid

%plot with most duplicate removed
figure(3)
stem(outputarray(:,1),outputarray(:,2))
xlabel('frequency')
ylabel('amplitude')
title('FFT with each duplicating frequency deleted')
grid

array2;
array3;
outputarray;
secondharm;
meanvalue;
check1;
check2;

%shows the user if the circuit is there or not.

if (check1==1 && check2==1)
    fprintf('circuit is detected\n')
end
if (check1==1 && check2==0)
    fprintf('first harmonics of the circuit is detected\n')
end
if (check1==0 && check2==0)
    fprintf('circuit not detected\n')
end


