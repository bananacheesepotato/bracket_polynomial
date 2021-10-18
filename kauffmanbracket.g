r:=PolynomialRing(Rationals,["A","x","y","z","t"]);
A:=r.1;

x:=r.2;
y:=r.3;
z:=r.4;
t:=r.5;

### expression has 3 parts, "words" corresponding to y, z, and t parts respectively.
# the polynomial is inserted to function in the 3 respective parts.
# step 1 is to smooth all k_n's into k^n.
# then we loop steps 2 and 3
# step 2 is to move all x groups to the rightmost side of each word
# step 3 is to move 
### important: insert words with 3 layers of brackets always

replace:=function(list,term,new) ###replaces first [x,y,z] in [[list]] with [a,b,c]
    local n,inc;
    inc:=0;
    for n in list do
        inc:=inc+1;
        if n=term then 
            list[inc]:=new;
            return list;
        fi;
    od;
    return list;
end;

increasepower:=function(list,a,c) ###replaces first [x,unknown,z] in [[list]] with larger power of unknown
    local n,inc;
    inc:=0;
    for n in list do
        inc:=inc+1;
        if list[inc][1]=a and list[inc][3]=c then 
            list[inc][2]:=list[inc][2]+1;
            return list;
        fi;
    od;
    return list;
end;

decreasepower:=function(list,a,c) ###replaces first [x,unknown,z] in [[list]] with smaller power of unknown
    local n,inc;
    inc:=0;
    for n in list do
        inc:=inc+1;
        if list[inc][1]=a and list[inc][3]=c then 
            list[inc][2]:=list[inc][2]-1;
            return list;
        fi;
    od;
    return list;
end;

findposition:=function(list,a,c) ###position function for [a,unknown,c] in [[list]]
    local n,inc,len;
    len:=Length(list);
    
    inc:=1;
    for n in list do
        inc:=inc+1;
        if inc>len then
            break;
        elif list[inc][1]=a and list[inc][3]=c then
            return inc;
        fi;
    od;
    return 0;
end;

atleastpower:=function(list,a,c,b) ##input 2 bracket list, output 1 if it has at least power of b
    local x,inc,len;
    len:=Length(list);
    
    inc:=1;
    for x in list do
        inc:=inc+1;
        if inc>len then
            break;
        elif list[inc][1]=a and list[inc][3]=c and list[inc][2]>=b then
            return 1;
        fi;
    od;
    return 0;
end;

part:=function(list,obj) ###tests if [x,y,z] in [[list]]
    local n;
    for n in list do
        if n=obj then
            return 1;
        fi;
    od;
    return 0;
end;

exists:=function(list,a,c) ##input 2 bracket list, output 1 if it has power of b
    local x,inc,len;
    len:=Length(list);
    
    inc:=1;
    for x in list do
        inc:=inc+1;
        if inc>len then
            break;
        elif list[inc][1]=a and list[inc][3]=c and list[inc][2]<>0 then
            return 1;
        fi;
    od;
    return 0;
end;

thereis:=function(list,a) ##input 2 bracket list, output 1 if it has term
    local x,inc,len;
    len:=Length(list);
    
    inc:=1;
    for x in list do
        inc:=inc+1;
        if inc>len then
            break;
        elif list[inc][1]=a then
            return 1;
        fi;
    od;
    return 0;
end;

atmostpower:=function(list,a,c,b) ##input 2 bracket list, output 1 if it has at most power of b
    local x,inc,len;
    len:=Length(list);
    
    inc:=1;
    for x in list do
        inc:=inc+1;
        if inc>len then
            break;
        elif list[inc][1]=a and list[inc][3]=c and list[inc][2]<=b then
            return 1;
        fi;
    od;
    return 0;
end;

issmooth:=function(b)
end;

isquasifinal:=function(b)
    local a,n,inc,increment,len,count;
    inc:=0;
    increment:=0;
    count:=0;
    len:=0;
    for a in b do
        inc:=inc+1;
        len:=Length(b[inc]);
        count:=0;
        increment:=0;
        
        for n in a do
            increment:=increment+1;
            if Position(a,n)>=len then
                break;
            elif Position(a,n)=1 then
                continue;
            
            elif n[3]<>0 and n[3]<>1 then ###subscripts smoothed
                return 0;
            
            elif n[3]=1 then ###one prime at end condition
                count:=count+1;
                if count>1 then
                    return 0;
                elif Position(a,n)<>len and Position(a,n)<>len-1 then
                    return 0;
                fi;
            
            elif n[1]=x then ###order is correct
                if Position(a,n)<>len then
                    return 0;
                fi;
            elif n[1]=y then
                if a[increment-1][1]=x or a[increment-1][1]=z or a[increment-1][1]=t then
                    return 0;
                fi;
            elif n[1]=z then
                if a[increment-1][1]=t or a[increment-1][1]=x then
                    return 0;
                elif a[increment+1][1]=y then
                    return 0;
                fi;
            elif n[1]=t then
                if a[increment-1][1]=x then
                    return 0;
                elif a[increment+1][1]=y or a[increment-1][1]=z then
                    return 0;
                fi;
            fi;
        od;
    od;
    return 1;
end;

isfinal:=function(b)
    local a,n,inc,increment,len,count,isx,isy,isz,ist;
    inc:=0;
    increment:=0;
    count:=0;
    len:=0;
    for a in b do
        isx:=0;
        isy:=0;
        isz:=0;
        ist:=0;
        inc:=inc+1;
        len:=Length(b[inc]);
        count:=0;
        increment:=0;
        
        for n in a do
            increment:=increment+1;
            if Position(a,n)>=len then
                break;
            elif Position(a,n)=1 then
                continue;
            
            elif n[3]<>0 and n[3]<>1 then ###subscripts smoothed
                return 0;
            
            elif n[3]=1 then ###one prime at end condition
                count:=count+1;
                if count>1 then
                    return 0;
                elif Position(a,n)<>len and Position(a,n)<>len-1 then
                    return 0;
                fi;
            
            elif n[1]=x then ###order is correct
                if Position(a,n)<>len then
                    return 0;
                fi;
                isx:=1;
            elif n[1]=y then
                if a[increment-1][1]=x or a[increment-1][1]=z or a[increment-1][1]=t then
                    return 0;
                fi;
                isy:=1;
            elif n[1]=z then
                if a[increment-1][1]=t or a[increment-1][1]=x then
                    return 0;
                elif a[increment+1][1]=y then
                    return 0;
                fi;
                isz:=1;
            elif n[1]=t then
                if a[increment-1][1]=x then
                    return 0;
                elif a[increment+1][1]=y or a[increment-1][1]=z then
                    return 0;
                fi;
                ist:=1;
            fi;
            if isx=1 and isy=1 and isz=1 and ist=1 then ###only 3 of 4 exist
                return 0;
            fi;
        od;
    od;
    return 1;
end;

isready:=function(b)
    local a,n,inc,increment,len,countx0,countx1,county0,county1,countz0,countz1,countt0,countt1,count;
    inc:=0;
    increment:=0;
    len:=0;
    for a in b do
        countx0:=0;
        countx1:=0;
        county0:=0;
        county1:=0;
        countz0:=0;
        countz1:=0;
        countt0:=0;
        countt1:=0;
        inc:=inc+1;
        len:=Length(b[inc]);
        count:=0;
        increment:=0;
        
        for n in a do
            increment:=increment+1;
            if Position(a,n)>=len then
                break;
            elif Position(a,n)=1 then
                continue;
            
            
            elif n[3]<>0 and n[3]<>1 then ###subscripts smoothed
                return 0;
            
            
            elif n[3]=0 then ###one prime of each type and one normal each type
                if n[1]=x then
                    countx0:=countx0+1;
                    if countx0>1 then
                        return 0;
                    fi;
                fi;
                if n[1]=y then
                    county0:=county0+1;
                    if county0>1 then
                        return 0;
                    fi;
                fi;
                if n[1]=z then
                    countz0:=countz0+1;
                    if countz0>1 then
                        return 0;
                    fi;
                fi;
                if n[1]=t then
                    countt0:=countt0+1;
                    if countt0>1 then
                        return 0;
                    fi;
                fi;
            elif n[3]=1 then
                if n[1]=x then
                    countx1:=countx1+1;
                    if countx1>1 then
                        return 0;
                    fi;
                fi;
                if n[1]=y then
                    county1:=county1+1;
                    if county1>1 then
                        return 0;
                    fi;
                fi;
                if n[1]=z then
                    countz1:=countz1+1;
                    if countz1>1 then
                        return 0;
                    fi;
                fi;
                if n[1]=t then
                    countt1:=countt1+1;
                    if countt1>1 then
                        return 0;
                    fi;
                fi;
            fi;
            if n[1]=x then ###order is correct
                if Position(a,n)<>len then
                    return 0;
                fi;
            elif n[1]=y then
                if a[increment-1][1]=x or a[increment-1][1]=z or a[increment-1][1]=t then
                    return 0;
                fi;
            elif n[1]=z then
                if a[increment-1][1]=t or a[increment-1][1]=x then
                    return 0;
                elif a[increment+1][1]=y then
                    return 0;
                fi;
            elif n[1]=t then
                if a[increment-1][1]=x then
                    return 0;
                elif a[increment+1][1]=y or a[increment-1][1]=z then
                    return 0;
                fi;
            fi;
        od;
    od;
    return 1;
end;

#### remove powers of 0
simplify:=function(m)
    local c,d,increment,inc;
    inc:=0;
    increment:=0;
    for c in m do
        inc:=inc+1;
        for d in c do
            increment:= increment+1;
            if Length(d)=3 then
                if d[2]=0 then
                    Remove(c,increment);
                    increment:=increment-1;
                fi;
                if d[1]=x and d[3]=1 then
                    d[3]:=0;
                fi;
                
            fi;
        od;
        increment:=0;
    od;
    return m;
end;

#### function to make words
mult:=function(n...)
    local a,output;
    output:=[];
    for a in n do
        Add(output,a);
    od;
    return output;
end;

#### function to make words
mult2:=function(n...)
    local a,b,output;
    output:=[];
    for a in n do
        for b in a do
            Add(output,b);
        od;
    od;
    return output;
end;


addinside:=function(list,obj,pos)
    local a,inc;
    inc:=pos;
    for a in obj do
        Add(list,a,inc);
        inc:=inc+1;
    od;
    return list;
end;

consolidate:=function(b)
    local a,trueoutput,trueinc,input,outputfinal,n,len,increment,inc;
    trueoutput:=StructuralCopy(b);
    trueinc:=0;
    inc:=0;
    increment:=0;
    for a in b do
        input:=Immutable(a);
        outputfinal:=StructuralCopy(a);
        inc:=inc+1;
        increment:=0;
        
        trueinc:=trueinc+1;
        len:= Length(b[inc]);
        for n in a do
            increment:=increment+1;
            if increment>=len then
                break;
            fi;
            if a[increment][1]=a[increment+1][1] and a[increment][3]=a[increment+1][3] then
                outputfinal[increment][2]:=outputfinal[increment][2]+outputfinal[increment+1][2];
                Remove(outputfinal,increment+1);
                Remove(a,increment+1);
                trueoutput[inc]:=outputfinal;
                increment:=increment-1;
                len:=len-1;
                
                #break;
            fi;
        od;
    od;
    simplify(trueoutput);
    return trueoutput;
end;

#### functions to semi-reduce words ---- shifting x
order := function(b)
    local a,trueoutput,trueinc,input,outputa,outputb,outputfinal,n,len,increment,inc;
    trueoutput:=StructuralCopy(b);
    trueinc:=0;
    inc:=0;
    increment:=0;
    for a in b do
        input:=Immutable(a);
        outputa:=StructuralCopy(a);
        outputb:=StructuralCopy(a);
        outputfinal:=StructuralCopy(a);
        inc:=inc+1;
        increment:=0;
        
        trueinc:=trueinc+1;
        len:= Length(b[inc]);
        for n in a do
            increment:=increment+1;
            if increment>len-1 then
                break;
            fi;
            
            if n[1]=x and a[increment+1][1]<>x then
                if n[2]>0 then
                    outputa[increment][2]:=input[increment][2]-1;
                    outputa[increment+1][3]:=input[increment+1][3]+1;
                    outputb[increment][2]:=input[increment][2]-1;
                    Add(outputb,[x,1,0],increment+2);
                        outputa[1]:=outputa[1]*(-A^4+1);
                        outputb[1]:=outputb[1]*(A^-2);
                    outputfinal:=mult(outputa,outputb);
                    simplify(outputfinal);
                    Remove(trueoutput,trueinc);
                    addinside(trueoutput,outputfinal,trueinc);
                    trueinc:=trueinc+1;
                    break;
                fi;
            fi;
        od;
    od;
    simplify(trueoutput);
    return trueoutput;
end;

#### function for smoothing subscripts
P:=function(n)
    local a,b,output,temp1,temp2;
    if n=0 then
        output:= [[[-A^2-A^-2],[x,0,0]]];
    elif n=1 then
        output:= [[[1],[x,1,0]]];
    elif n>1 then
        temp1:=P(n-1);
        temp2:=P(n-2);
        for a in temp1 do
            a[2][2]:=a[2][2]+1;
            a[1]:=a[1]*-A^-2;
        od;
        for b in temp2 do
            b[1]:=b[1]*(-A^2);
        od;
        output:=mult2(temp1,temp2);
    elif n<0 then
        temp1:=P(n+1);
        temp2:=P(n+2);
        for a in temp1 do
            a[2][2]:=a[2][2]+1;
            a[1]:=a[1]*-A^-4;
        od;
        for b in temp2 do
            b[1]:=b[1]*(-A^-2);
        od;
        output:=mult2(temp1,temp2);
    fi;
    return output;
end;

Pref:=function(n)
    if n=0 then
        return -A^2-A^-2;
    elif n=1 then
        return x;
    elif n>1 then 
        return -A^-2*x*Pref(n-1)-A^2*Pref(n-2);
    fi;
end;

combine:=function(b)
    local a,trueoutput,trueinc,input,outputfinal,n,len,len2,inc,inc2,indicator,c;
    trueoutput:=StructuralCopy(b);
    trueinc:=0;
    inc:=0;
    inc2:=0;
    indicator:=1;
    len:=Length(b);
    for a in [1..len] do
        inc:=inc+1;
        inc2:=0;
        if inc>len then
            break;
        fi;
        for n in [1..len] do
            inc2:=inc2+1;
            if inc2>len then
                break;
            fi;
            if inc=inc2 then
            elif Length(b[inc])=Length(b[inc2]) then
                len2:=Length(b[inc]);
                for c in [2..len2] do
                    if b[inc][c]=b[inc2][c] then
                        indicator:=1;
                    else
                        indicator:=0;
                        break;
                    fi;
                od;
                if indicator=1 then
                    b[inc][1]:=b[inc][1]+b[inc2][1];
                    Remove(b,inc2);
                    inc2:=inc2-1;
                    len:=len-1;
                fi;
            fi;
        od;
    od;
    simplify(b);
    return b;
end;

#### functions to semi-reduce words ---- subscripts
smooth := function(b)
    local a,trueoutput,input,outputa,outputb,outputfinal,n,len,increment,inc,trueinc,c,outputsemifinal;
    trueoutput:=StructuralCopy(b);
    trueinc:=0;
    inc:=0;
    increment:=0;
    for a in b do
        input:=Immutable(a);
        outputa:=StructuralCopy(a);
        outputb:=StructuralCopy(a);
        outputfinal:=StructuralCopy(a);
        trueinc:=trueinc+1;
        inc:=inc+1;
        len:=Length(b[inc]);
        increment:=0;
        for n in a do
            increment:=increment+1;
            if increment> len then
                break;
            fi;
            if n[1]=x then
                if n[3]<>0 and n[3]<>1 then
                    if n[3]>=2 or n[3]<=-1 then
                        Remove(trueoutput,trueinc);
                        
                        
                        for c in P(n[3]) do
                            outputsemifinal:=StructuralCopy(a);
                            outputsemifinal[1]:=outputsemifinal[1]*c[1][1];
                            outputsemifinal[increment]:=c[2];
                            Add(trueoutput,outputsemifinal,trueinc);
                            trueinc:=trueinc+1;
                            
                        od;
                        trueinc:=trueinc-1;
                        
                    fi;
                fi;
            elif n[1]=y then
                if n[3]<>0 and n[3]<>1 then
                    if n[3]>=2 then
                        outputa[increment][3]:=input[increment][3]-1;
                        outputb[increment][3]:=input[increment][3]-2;
                        Add(outputa,[x,1,0],increment+1);
                        outputa[1]:=outputa[1]*(-A^-2);
                        outputb[1]:=outputb[1]*(-A^2);
                        outputfinal:=mult(outputa,outputb);
                        simplify(outputfinal);
                        Remove(trueoutput,trueinc);
                        addinside(trueoutput,outputfinal,trueinc);
                        trueinc:=trueinc+1;
                        break;
                    elif n[3]<=-1 then
                        outputa[increment][3]:=input[increment][3]+1;
                        outputb[increment][3]:=input[increment][3]+2;
                        Add(outputa,[x,1,0],increment+1);
                        outputa[1]:=outputa[1]*(-A^-4);
                        outputb[1]:=outputb[1]*(-A^-2);
                        outputfinal:=mult(outputa,outputb);
                        simplify(outputfinal);
                        Remove(trueoutput,trueinc);
                        addinside(trueoutput,outputfinal,trueinc);
                        trueinc:=trueinc+1;
                        break;
                    fi;
                fi;
            elif n[1]=z then
                if n[3]<>0 and n[3]<>1 then
                    if n[3]>=2 then
                        outputa[increment][3]:=input[increment][3]-1;
                        outputb[increment][3]:=input[increment][3]-2;
                        Add(outputa,[x,1,0],increment+1);
                        outputa[1]:=outputa[1]*(-A^-2);
                        outputb[1]:=outputb[1]*(-A^2);
                        outputfinal:=mult(outputa,outputb);
                        simplify(outputfinal);
                        Remove(trueoutput,trueinc);
                        addinside(trueoutput,outputfinal,trueinc);
                        trueinc:=trueinc+1;
                        break;
                    elif n[3]<=-1 then
                        outputa[increment][3]:=input[increment][3]+1;
                        outputb[increment][3]:=input[increment][3]+2;
                        Add(outputa,[x,1,0],increment+1);
                        outputa[1]:=outputa[1]*(-A^-4);
                        outputb[1]:=outputb[1]*(-A^-2);
                        outputfinal:=mult(outputa,outputb);
                        simplify(outputfinal);
                        Remove(trueoutput,trueinc);
                        addinside(trueoutput,outputfinal,trueinc);
                        trueinc:=trueinc+1;
                        break;
                    fi;
                fi;
            elif n[1]=t then
                if n[3]<>0 and n[3]<>1 then
                    if n[3]>=2 then
                        outputa[increment][3]:=input[increment][3]-1;
                        outputb[increment][3]:=input[increment][3]-2;
                        Add(outputa,[x,1,0],increment+1);
                        outputa[1]:=outputa[1]*(-A^-2);
                        outputb[1]:=outputb[1]*(-A^2);
                        outputfinal:=mult(outputa,outputb);
                        simplify(outputfinal);
                        Remove(trueoutput,trueinc);
                        addinside(trueoutput,outputfinal,trueinc);
                        trueinc:=trueinc+1;
                        break;
                    elif n[3]<=-1 then
                        outputa[increment][3]:=input[increment][3]+1;
                        outputb[increment][3]:=input[increment][3]+2;
                        Add(outputa,[x,1,0],increment+1);
                        outputa[1]:=outputa[1]*(-A^-4);
                        outputb[1]:=outputb[1]*(-A^-2);
                        outputfinal:=mult(outputa,outputb);
                        simplify(outputfinal);
                        Remove(trueoutput,trueinc);
                        addinside(trueoutput,outputfinal,trueinc);
                        trueinc:=trueinc+1;
                        break;
                    fi;
                fi;
            fi;
        od;
    od;
    simplify(trueoutput);
    return trueoutput;
end;

quasifinal:= function(b)
    local a,trueoutput,trueinc,input,outputa,outputb,outputc,outputfinal,n,len,increment,inc,placeholder1;
    trueoutput:=StructuralCopy(b);
    trueinc:=0;
    inc:=0;
    increment:=0;
    placeholder1:=0;
    for a in b do
        input:=Immutable(a);
        outputa:=StructuralCopy(a);
        outputb:=StructuralCopy(a);
        outputc:=StructuralCopy(a);
        outputfinal:=StructuralCopy(a);
        inc:=inc+1;
        trueinc:=trueinc+1;
        len:=Length(b[inc]);
        if part(a,[y,1,1])=1 then  #####conditions 2,3,4,5
            if part(a,[z,1,1])=1 then ###condition 3
                outputa[1]:=input[1]*(A^2);
                outputb[1]:=input[1]*(2);
                outputc[1]:=input[1]*(A^-2);
                if exists(a,y,0)=1 then
                    outputa:=increasepower(outputa,y,0); ###check layering on this shit
                else
                    Add(outputa,[y,1,0],2);
                fi;
                Remove(outputa,Position(outputa,[y,1,1])); ###is it a or outputa in Position?
                if exists(a,z,0)=1 then
                    outputa:=increasepower(outputa,z,0);
                else
                    Add(outputa,[z,1,0],findposition(outputa,y,0)+1);
                fi;
                Remove(outputa,Position(outputa,[z,1,1]));
                Remove(outputb,Position(outputb,[y,1,1]));
                Remove(outputb,Position(outputb,[z,1,1]));
                Add(outputb,[t,1,0]);
                Remove(outputc,Position(outputc,[y,1,1]));
                Remove(outputc,Position(outputc,[z,1,1]));
                Add(outputc,[t,1,-1]);
                Add(outputc,[x,1,0]);
                outputfinal:=mult(outputa,outputb,outputc);
                simplify(outputfinal);
                Remove(trueoutput,trueinc);
                addinside(trueoutput,outputfinal,trueinc);
                trueinc:=trueinc+2;
                break;
            elif atleastpower(a,z,0,1)=1 then ###condition 2
                outputa[1]:=input[1]*(A^2);
                outputb[1]:=input[1]*(2);
                outputc[1]:=input[1]*(A^-2);
                if exists(a,y,0)=1 then
                    outputa:=increasepower(outputa,y,0);
                else
                    Add(outputa,[y,1,0],2);
                fi;
                Remove(outputa,Position(outputa,[y,1,1]));
                outputa:=decreasepower(outputa,z,0);
                Add(outputa,[z,1,-1],findposition(outputa,z,0)+1);
                Remove(outputb,Position(outputb,[y,1,1]));
                outputb:=decreasepower(outputb,z,0);
                Add(outputb,[t,1,1]);
                Remove(outputc,Position(outputc,[y,1,1]));
                outputc:=decreasepower(outputc,z,0);
                Add(outputc,[t,1,0]);
                Add(outputc,[x,1,0]);
                outputfinal:=mult(outputa,outputb,outputc);
                simplify(outputfinal);
                Remove(trueoutput,trueinc);
                addinside(trueoutput,outputfinal,trueinc);
                trueinc:=trueinc+2;
                break;
            elif part(a,[t,1,1])=1 then ###condition 5
                outputa[1]:=input[1]*(A^2);
                outputb[1]:=input[1]*(2);
                outputc[1]:=input[1]*(A^-2);
                if exists(a,y,0)=1 then
                    outputa:=increasepower(outputa,y,0);
                else
                    Add(outputa,[y,1,0],2);
                fi;
                Remove(outputa,Position(outputa,[y,1,1]));
                if exists(a,t,0)=1 then
                    outputa:=increasepower(outputa,t,0);
                else
                    Add(outputa,[t,1,0],findposition(outputa,y,0)+1);
                fi;
                Remove(outputa,Position(outputa,[t,1,1]));
                Remove(outputb,Position(outputb,[y,1,1]));
                if exists(a,t,0)=1 then
                    placeholder1:=outputb[findposition(outputb,t,0)][2];
                    Remove(outputb,findposition(outputb,t,0));
                else
                    placeholder1:=1;
                fi;
                Remove(outputb,Position(outputb,[t,1,1]));
                Add(outputb,[z,1,0]);
                Add(outputb,[t,placeholder1-1,0]);
                Remove(outputc,Position(outputc,[y,1,1]));
                if exists(a,t,0)=1 then
                    placeholder1:=outputc[findposition(outputc,t,0)][2];
                    Remove(outputc,findposition(outputc,t,0));
                else
                    placeholder1:=1;
                fi;
                Remove(outputc,Position(outputc,[t,1,1]));
                Add(outputc,[z,1,-1]);
                Add(outputc,[t,placeholder1-1,0]);
                Add(outputc,[x,1,0]);
                outputfinal:=mult(outputa,outputb,outputc);
                simplify(outputfinal);
                Remove(trueoutput,trueinc);
                addinside(trueoutput,outputfinal,trueinc);
                trueinc:=trueinc+2;
                break;
            elif atleastpower(a,t,0,1)=1 then ###condition 4
                outputa[1]:=input[1]*(A^2);
                outputb[1]:=input[1]*(2);
                outputc[1]:=input[1]*(A^-2);
                if exists(a,y,0)=1 then
                    outputa:=increasepower(outputa,y,0);
                else
                    Add(outputa,[y,1,0],2);
                fi;
                Remove(outputa,Position(outputa,[y,1,1]));
                outputa:=decreasepower(outputa,t,0);
                Add(outputa,[t,1,-1],findposition(outputa,t,0)+1);
                Remove(outputb,Position(outputb,[y,1,1]));
                if exists(a,t,0)=1 then
                    placeholder1:=outputb[findposition(outputb,t,0)][2];
                    Remove(outputb,findposition(outputb,t,0));
                else
                    placeholder1:=1;
                fi;
                Add(outputb,[z,1,1]);
                Add(outputb,[t,placeholder1-1,0]);
                Remove(outputc,Position(outputc,[y,1,1]));
                if exists(a,t,0)=1 then
                    placeholder1:=outputc[findposition(outputc,t,0)][2];
                    Remove(outputc,findposition(outputc,t,0));
                else
                    placeholder1:=1;
                fi;
                Add(outputc,[z,1,0]);
                Add(outputc,[t,placeholder1-1,0]);
                Add(outputc,[x,1,0]);
                outputfinal:=mult(outputa,outputb,outputc);
                
                simplify(outputfinal);
                Remove(trueoutput,trueinc);
                addinside(trueoutput,outputfinal,trueinc);
                trueinc:=trueinc+2;
                break;
            fi;
        elif part(a,[z,1,1])=1 then #####conditions 6,7
            if part(a,[t,1,1])=1 then ###condition 7
                outputa[1]:=input[1]*(A^2);
                outputb[1]:=input[1]*(2);
                outputc[1]:=input[1]*(A^-2);
                if exists(a,z,0)=1 then
                    outputa:=increasepower(outputa,z,0);
                else
                    Add(outputa,[z,1,0],Position(outputa,[z,1,1])-1);
                fi;
                Remove(outputa,Position(outputa,[z,1,1]));
                if exists(a,t,0)=1 then
                    outputa:=increasepower(outputa,t,0);
                else
                    Add(outputa,[t,1,0],findposition(outputa,z,0)+1);
                fi;
                Remove(outputa,Position(outputa,[t,1,1]));
                Add(outputb,[y,1,0]);
                if exists(a,z,0)=1 then
                    placeholder1:=outputb[findposition(outputb,z,0)][2];
                    Remove(outputb,findposition(outputb,z,0));
                else
                    placeholder1:=0;
                fi;
                Remove(outputb,Position(outputb,[z,1,1]));
                Add(outputb,[z,placeholder1,0]);
                if exists(a,t,0)=1 then
                    placeholder1:=outputb[findposition(outputb,t,0)][2];
                    Remove(outputb,findposition(outputb,t,0));
                else
                    placeholder1:=0;
                fi;
                Remove(outputb,Position(outputb,[t,1,1]));
                Add(outputb,[t,placeholder1,0]);
                Add(outputc,[y,1,-1]);
                if exists(a,z,0)=1 then
                    placeholder1:=outputc[findposition(outputc,z,0)][2];
                    Remove(outputc,findposition(outputc,z,0));
                else
                    placeholder1:=0;
                fi;
                Remove(outputc,Position(outputc,[z,1,1]));
                Add(outputc,[z,placeholder1,0]);
                if exists(a,t,0)=1 then
                    placeholder1:=outputc[findposition(outputc,t,0)][2];
                    Remove(outputc,findposition(outputc,t,0));
                else
                    placeholder1:=0;
                fi;
                Remove(outputc,Position(outputc,[t,1,1]));
                Add(outputc,[t,placeholder1,0]);
                Add(outputc,[x,1,0]);
                outputfinal:=mult(outputa,outputb,outputc);
                simplify(outputfinal);
                Remove(trueoutput,trueinc);
                addinside(trueoutput,outputfinal,trueinc);
                trueinc:=trueinc+2;
                break;
            elif atleastpower(a,t,0,1)=1 then ###condition 6
                outputa[1]:=input[1]*(A^2);
                outputb[1]:=input[1]*(2);
                outputc[1]:=input[1]*(A^-2);
                if exists(a,z,0)=1 then
                    outputa:=increasepower(outputa,z,0);
                else
                    Add(outputa,[z,1,0],Position(outputa,[z,1,1])-1);
                fi;
                Remove(outputa,Position(outputa,[z,1,1]));
                if exists(a,t,0)=1 then ##**c always >0 here so unnecessary
                    outputa:=decreasepower(outputa,t,0);
                else
                    Add(outputa,[t,-1,0],findposition(outputa,t,0)+1);
                fi;
                Add(outputa,[t,0,-1],findposition(outputa,t,0)+1); ###########################hotfix here swapped powers
                if exists(a,z,0)=1 then
                    placeholder1:=outputb[findposition(outputb,z,0)][2];
                    Remove(outputb,findposition(outputb,z,0));
                else
                    placeholder1:=0;
                fi;
                Remove(outputb,Position(outputb,[z,1,1]));
                Add(outputb,[y,1,1]);
                Add(outputb,[z,placeholder1,0]);
                if exists(a,t,0)=1 then ###always exists
                    placeholder1:=outputb[findposition(outputb,t,0)][2];
                    Remove(outputb,findposition(outputb,t,0));
                else
                    placeholder1:=0;
                fi;
                Add(outputb,[t,placeholder1-1,0]);
                if exists(a,z,0)=1 then
                    placeholder1:=outputc[findposition(outputc,z,0)][2];
                    Remove(outputc,findposition(outputc,z,0));
                else
                    placeholder1:=0;
                fi;
                Remove(outputc,Position(outputc,[z,1,1]));
                Add(outputc,[y,1,0]);
                Add(outputc,[z,placeholder1,0]);
                if exists(a,t,0)=1 then ###should always exist
                    placeholder1:=outputc[findposition(outputc,t,0)][2];
                    Remove(outputc,findposition(outputc,t,0));
                else
                    placeholder1:=0;
                fi;
                Add(outputc,[t,placeholder1-1,0]);
                Add(outputc,[x,1,0]);
                outputfinal:=mult(outputa,outputb,outputc);
                simplify(outputfinal);
                Remove(trueoutput,trueinc);
                addinside(trueoutput,outputfinal,trueinc);
                trueinc:=trueinc+2;
                break;
            fi;
        fi;
    od;
    return trueoutput;
end;

final:= function(b)
    local a,trueinc,trueoutput,input,outputa,outputb,outputc,outputd,outpute,outputf,outputg,outputfinal,n,len,increment,inc,placeholder1;
    trueoutput:=StructuralCopy(b);
    trueinc:=0;
    inc:=0;
    increment:=0;
    placeholder1:=0;
    for a in b do
        input:=Immutable(a);
        outputa:=StructuralCopy(a);
        outputb:=StructuralCopy(a);
        outputc:=StructuralCopy(a);
        outputd:=StructuralCopy(a);
        outpute:=StructuralCopy(a);
        outputf:=StructuralCopy(a);
        outputg:=StructuralCopy(a);
        outputfinal:=StructuralCopy(a);
        inc:=inc+1;
        trueinc:=trueinc+1;
        len:= Length(b[inc]);

        if part(a,[t,1,1])=1 and thereis(a,x)=1 and thereis(a,y)=1 and thereis(a,z)=1 and thereis(a,t)=1 then
            outputa[1]:=input[1]*(-2*A^2);
            outputb[1]:=input[1]*(2*A^2);
            outputd[1]:=input[1]*(2*A^2);
            outputf[1]:=input[1]*(-2*A^2);
            outputg[1]:=input[1]*(-1);
            outputa:=decreasepower(outputa,t,0);
            outputa:=decreasepower(outputa,x,0);
            Add(outputa,[t,1,1],findposition(outputa,t,0)+1);
            outputb:=decreasepower(outputb,y,0);
            outputb:=decreasepower(outputb,x,0);
            placeholder1:=outputb[findposition(outputb,t,0)][2];
            Remove(outputb,findposition(outputb,t,0));
            Add(outputb,[z,1,1]);
            Add(outputb,[t,placeholder1-1,0]);
            outputc:=decreasepower(outputc,y,0);
            outputc:=decreasepower(outputc,x,0);
            placeholder1:=outputc[findposition(outputc,t,0)][2];
            Remove(outputc,findposition(outputc,t,0));
            Add(outputc,[z,1,0]);
            Add(outputc,[t,placeholder1-1,0]);
            Add(outputc,[x,1,0]);
            outputd:=decreasepower(outputd,x,0);
            placeholder1:=outputd[findposition(outputd,z,0)][2];
            Remove(outputd,findposition(outputd,z,0));
            Add(outputd,[y,1,1]);
            Add(outputd,[z,placeholder1-1,0]);
            placeholder1:=outputd[findposition(outputd,t,0)][2];
            Remove(outputd,findposition(outputd,t,0));
            Add(outputd,[t,placeholder1-1,0]);
            outpute:=decreasepower(outpute,x,0);
            placeholder1:=outpute[findposition(outpute,z,0)][2];
            Remove(outpute,findposition(outpute,z,0));
            Add(outpute,[y,1,0]);
            Add(outpute,[z,placeholder1-1,0]);
            placeholder1:=outpute[findposition(outpute,t,0)][2];
            Remove(outpute,findposition(outpute,t,0));
            Add(outpute,[t,placeholder1-1,0]);
            Add(outpute,[x,1,0]);
            outputf:=decreasepower(outputf,y,0);
            outputf:=decreasepower(outputf,z,0);
            outputf:=decreasepower(outputf,x,0);
            Add(outputf,[t,1,1]);
            outputg:=decreasepower(outputg,y,0);
            outputg:=decreasepower(outputg,z,0);
            outputg:=decreasepower(outputg,x,0);
            Add(outputg,[t,1,0]);
            Add(outputg,[x,1,0]);
            outputfinal:=mult(outputa,outputb,outputc,outputd,outpute,outputf,outputg);
            simplify(outputfinal);
            Remove(trueoutput,trueinc);
            addinside(trueoutput,outputfinal,trueinc);
            trueinc:=trueinc+2;
            break;
        elif thereis(a,x)=1 and thereis(a,y)=1 and thereis(a,z)=1 and thereis(a,t)=1 then
            outputa[1]:=input[1]*(-2*A^4);
            outputb[1]:=input[1]*(-2*A^2);
            outputc[1]:=input[1]*(-1);
            outputd[1]:=input[1]*(2*A^2);
            outputf[1]:=input[1]*(-2*A^2);
            outputg[1]:=input[1]*(-1);
            outputa:=increasepower(outputa,t,0);
            outputa:=decreasepower(outputa,x,0);
            Remove(outputa,Position(outputa,[t,1,1]));
            outputb:=decreasepower(outputb,x,0);
            placeholder1:=outputb[findposition(outputb,z,0)][2];
            Remove(outputb,findposition(outputb,z,0));
            Add(outputb,[y,1,0]);
            Add(outputb,[z,placeholder1-1,0]);
            placeholder1:=outputb[findposition(outputb,t,0)][2];
            Remove(outputb,findposition(outputb,t,0));
            Add(outputb,[t,placeholder1,0]);
            outputc:=decreasepower(outputc,x,0);
            placeholder1:=outputc[findposition(outputc,z,0)][2];
            Remove(outputc,findposition(outputc,z,0));
            Add(outputc,[y,1,-1]);
            Add(outputc,[z,placeholder1-1,0]);
            placeholder1:=outputc[findposition(outputc,t,0)][2];
            Remove(outputc,findposition(outputc,t,0));
            Add(outputc,[t,placeholder1,0]);
            Add(outputc,[x,1,0]);
            outputd:=decreasepower(outputd,y,0);
            outputd:=decreasepower(outputd,z,0);
            outputd:=decreasepower(outputd,x,0);
            Add(outputd,[t,1,1]);
            outpute:=decreasepower(outpute,y,0);
            outpute:=decreasepower(outpute,z,0);
            outpute:=decreasepower(outpute,x,0);
            Add(outpute,[t,1,0]);
            Add(outpute,[x,1,0]);
            outputf:=decreasepower(outputf,y,0);
            outputf:=decreasepower(outputf,x,0);
            placeholder1:=outputf[findposition(outputf,t,0)][2];
            Remove(outputf,findposition(outputf,t,0));
            Add(outputf,[z,1,0]);
            Add(outputf,[t,placeholder1,0]);
            outputg:=decreasepower(outputg,y,0);
            outputg:=decreasepower(outputg,x,0);
            placeholder1:=outputg[findposition(outputg,t,0)][2];
            Remove(outputg,findposition(outputg,t,0));
            Add(outputg,[z,1,-1]);
            Add(outputg,[t,placeholder1,0]);
            Add(outputg,[x,1,0]);
            outputfinal:=mult(outputa,outputb,outputc,outputd,outpute,outputf,outputg);
            simplify(outputfinal);
            Remove(trueoutput,trueinc);
            addinside(trueoutput,outputfinal,trueinc);
            trueinc:=trueinc+2;
            break;
        else
            break;
        fi;
    od;
    return trueoutput;
end;

removepowersofzero:=function(b)
    local c,inc,len;
    inc:=0;
    len:=Length(b);
    for c in b do
        inc:=inc+1;
        if b[inc][1][1]=0 or b[inc][1][1]=A*0 then
            Remove(b,inc);           
            inc:=inc-1;
        fi;
    od;
    return b;
end;

convert:=function(b)
    local a,c,inc,len;
    inc:=0;
    len:=Length(b);
    for c in b do
        for a in c do
            if a[1]=x and a[3]=0 then
                Remove(a,3);
                a[1]:=0;
            elif a[1]=y and a[3]=0 then
                Remove(a,3);
                a[1]:=1;
            elif a[1]=z and a[3]=0 then
                Remove(a,3);
                a[1]:=2;
            elif a[1]=t and a[3]=0 then
                Remove(a,3);
                a[1]:=3;
            elif a[1]=y and a[3]=1 then
                Remove(a,3);
                a[1]:=4;
            elif a[1]=z and a[3]=1 then
                Remove(a,3);
                a[1]:=5;
            elif a[1]=t and a[3]=1 then
                Remove(a,3);
                a[1]:=6;
            fi;
        od;
    od;
    return b;
end;

kauffmanbracket:=function(b)
    local finaloutput;
    finaloutput:=StructuralCopy(b);
    repeat
        repeat
            repeat
                finaloutput:=smooth(finaloutput);
                finaloutput:=order(finaloutput);
                finaloutput:=consolidate(finaloutput);
            until isready(finaloutput)=1;
            finaloutput:=simplify(finaloutput);
            finaloutput:=quasifinal(finaloutput);
        until isquasifinal(finaloutput)=1;
        finaloutput:=simplify(finaloutput);
        finaloutput:=final(finaloutput);
    until isfinal(finaloutput)=1;
    finaloutput:=combine(finaloutput);
    finaloutput:=removepowersofzero(finaloutput);
    finaloutput:=convert(finaloutput);
    return finaloutput;
end;



[[[1],[y,1,1],[t,1,-1],[x,1,2]]]; #

    
kauffmanbrackettest:=function(b)
    local finaloutput;

    finaloutput:=StructuralCopy(b);
    # repeat
    #     repeat
            repeat
                finaloutput:=smooth(finaloutput);
                finaloutput:=order(finaloutput);
                finaloutput:=consolidate(finaloutput);
            until isready(finaloutput)=1;
    #         quasifinal(finaloutput);
    #     until isquasifinal(finaloutput)=1;
    #     final(finaloutput);
    # until isfinal(finaloutput)=1;
    return finaloutput;
end;

    
                     
