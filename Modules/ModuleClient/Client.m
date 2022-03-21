classdef Client < handle 
    properties (Access=private)
       prenom = char.empty();
       nom = char.empty();
       nas = char.empty();
       nbCompte = 0;
       compte = Compte();        
    end
    methods (Access = public)
        function nouveauclient = Client (prenom,nom,nas)
            assert(nargin~=0);
            nouveauclient.prenom = prenom;
            nouveauclient.nom = nom;
            nouveauclient.nas=nas;   
            validateattributes(prenom,'char','scalar');
            validateattributes(nom,'char','scalar');
            validateattributes(nas,'char',{'scalar'},{'size',[1,9]});
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


        function [refCompte] = ObtenirCompte(tailleCompte,indiceCompte)
            validateattributes(indiceCompte,'double',{'scalar','integer','positive'});
            assert(indiceCompte<=tailleCompte);
            refCompte = indiceCompte(tailleCompte);
        end


        function ajouterCompte(ref, nouveauCompte)
            if isequal(nouveauCompte,Compte)
                validateattributes(nouveauCompte,'scalar');
                assert(getNbComptes.nouveauCompte==nouveauCompte,'Ce compte est deja relier a ce profil client.');
                
        end
    end
    


end