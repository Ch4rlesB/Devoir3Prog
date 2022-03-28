classdef Client < handle 
    properties (Access=private)
       prenom = char.empty();
       nom = char.empty();
       nas = char.empty();
       nbCompte = 0;
       compteTab = Compte.empty();        
    end
    methods (Access = public)
        function nouveauclient = Client (nouvPrenom,nouvNom,nouvNas)
            if nargin~=0
                validateattributes(nouvPrenom,{'char'},{'row'});
                validateattributes(nouvnom,{'char'},{'row'});
                validateattributes(nouvnas,{'char'},{'row','size' , [1,9]});
                nouveauclient.prenom = nouvPrenom;
                nouveauclient.nom = nouvNom;
                nouveauclient.nas=nouvNas;   
            end
        end


        function [valeurLue] = getPrenom (objet)
            valeurLue = objet.prenom;
        end


        function [valeurLue] = getNom (objet)
            valeurLue = objet.nom;
        end


        function [valeurLue] = getNumeroAssuranceSociale (objet)
            valeurLue = objet.nas;
        end


        function [valeurLue] = getNbComptes (objet)
            valeurLue = objet.nbCompte;
        end


        function [refCompte] = ObtenirCompte(ref,indiceCompte)
            validateattributes(indiceCompte,'double',{'scalar','integer','positive'});
            assert(indiceCompte<=ref.nbCompte);
            refCompte = ref.compteTab(indiceCompte);
        end


        function AjouterCompte(ref, nouveauCompte)
        
            validateattributes(nouveauCompte,{'Compte'},{'scalar'});
            for i=1:size(ref.compteTab,2)
                assert(nouveauCompte~=ref.compteTab(i),'Ce compte est deja relier a ce profil client.');
            end
            ref.compteTab = [ref.compteTab;nouveauCompte];
            ref.nbCompte = ref.nbCompte + 1;
                     
        end

        function egal = eq(ref,client)
            if ~isequal(client,Client)
                egal = 0;
            else
                for i=1:size(ref.compteTab,2)
                    if (Compte.eq(ref,client)==1)
                        egal = 1;
                    end
                end
            end
        end
    end
    


end