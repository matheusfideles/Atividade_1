include("Matrices.jl")
include("Tests.jl")
using Plots, LaTeXStrings

#Função para ajustar os nomes dos métodos para colocar nos eixos dos gráficos
function renomearEixo(metodos)
    novo=[]
    for met in metodos
        if met=="inv"
            push!(novo,"Inversa")
        elseif met=="plu"
            push!(novo,"LU com Piv. Parcial")
        elseif met=="lu"
            push!(novo,"LU")
        else
            push!(novo,"Cholesky")
        end
    end
    novo=reshape(novo,1,length(novo))
    return novo
end

#Gráfico dispersão erro relativo
function disp_erro(i,simet,resp,metodos,n_conj)
    metodos=renomearEixo(metodos)
    erros=[]
    for k in eachindex(metodos)
        push!(erros,resp[:,1,k])
    end

    #Plotando e vendo se precisa passar log se Lu tá no meio
    luInMet="LU" in metodos
    if luInMet
        fig=plot(n_conj,erros,xlabel=L"n", yscale=:log10, ylabel="Log. Erro rel.", label=metodos, legend=:topleft)
    else
        fig=plot(n_conj,erros,xlabel=L"n", ylabel="Erro rel.", label=metodos, legend=:topleft)
    end

    #Salvando
    if simet && luInMet
        savefig(fig,"images/Gráfico - Log Erros Rel - Simétrico - ("*Char(64+i)*").png")
    elseif simet && !luInMet
        savefig(fig,"images/Gráfico - Erros Rel - Simétrico - ("*Char(64+i)*").png")
    elseif !simet && luInMet
        savefig(fig, "images/Gráfico - Log Erros Rel - Não Simétrico - ("*Char(64+i)*")")
    else
        savefig(fig, "images/Gráfico - Erros Rel - Não Simétrico - ("*Char(64+i)*").png")
    end
end
    
#Gráfico dispersão resíduo relativo
function disp_residuo(i,simet,resp,metodos,n_conj)
    metodos=renomearEixo(metodos)
    residuos=[]
    for k in eachindex(metodos)
        push!(residuos,resp[:,2,k])
    end

    #Plotando e vendo se precisa passar log se Lu tá no meio
    luInMet="LU" in metodos
    if luInMet
        fig=plot(n_conj,residuos,xlabel=L"n", yscale=:log10, ylabel="Log. Resíd. rel.", label=metodos, legend=:topleft)
    else
        fig=plot(n_conj,residuos,xlabel=L"n", ylabel="Resíduo rel.", label=metodos, legend=:topleft)
    end

    #Salvando
    if simet && luInMet
        savefig(fig,"images/Gráfico - Log Resid Rel - Simétrico - ("*Char(64+i)*").png")
    elseif simet && !luInMet
        savefig(fig,"images/Gráfico - Resíduo Rel - Simétrico - ("*Char(64+i)*").png")
    elseif !simet && luInMet
        savefig(fig, "images/Gráfico - Log Resid Rel - Não Simétrico - ("*Char(64+i)*")")
    else
        savefig(fig, "images/Gráfico - Resíduo Rel - Não Simétrico - ("*Char(64+i)*").png")
    end
end

#Gráficos de dispersão de tempo com base em uma tabela de resultados informada e um conjunto de métodos
#Separamos no caso em que avaliamos o método pela inversa/LU ou não. Se sim, passamos log(x) no eixo do tempo
#Isso ajuda a contornar o problema de dif. de grandeza, já que sabemos que usa mais tempo nesses casos
function disp_tempo_log(resp,metodos,n_conj)
    #Pegando o tempo de cada método
    tempos=[]
    for k in eachindex(metodos)
        push!(tempos, resp[:,3,k])
    end
    #Plotando
    fig=plot(n_conj, tempos, yscale=:log10, xlabel=L"n", ylabel="Log. Tempo", label=metodos,legend=:topleft)
    return fig
end

#Dispersão de tempo sem log, para quando não tem inversa
function disp_tempo(resp,metodos,n_conj)
    #Pegando o tempo de cada método
    tempos=[]
    for k in eachindex(metodos)
        push!(tempos, resp[:,3,k])
    end
    #Plotando
    fig=plot(n_conj, tempos, xlabel=L"n", ylabel="Tempo de execução (s)", label=metodos,legend=:topleft)
    return fig
end

#Função que faz a dispersão do tempo, verificando se precisa passar log ou não
#Pressupomos que já esteja em ordem, ou seja, resp[:,:,j] refere-se ao j-ésimo método no vetor
function disp_tempo_main(i,simet,resp,metodos,n_conj)
    metodos=renomearEixo(metodos)
    #Vendo se usamos o gráfico com log ou não
    flag="Inversa" in metodos || "LU" in metodos
    if flag
        fig=disp_tempo_log(resp,metodos,n_conj)
    else
        fig=disp_tempo(resp,metodos,n_conj)
    end

    #Salvando
    if simet && flag
        savefig(fig,"images/Gráfico - Tempos log - Simétrico - ("*Char(64+i)*").png")
    elseif simet && !flag
        savefig(fig,"images/Gráfico - Tempos - Simétrico - ("*Char(64+i)*").png")
    elseif !simet && flag
        savefig(fig,"images/Gráfico - Tempos log - Não Simétrico - ("*Char(64+i)*").png")
    else
        savefig(fig,"images/Gráfico - Tempos - Não Simétrico - ("*Char(64+i)*").png")
    end
end
