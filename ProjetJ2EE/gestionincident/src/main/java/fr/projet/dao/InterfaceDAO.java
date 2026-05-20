package fr.projet.dao;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Interface générique pour les opérations CRUD.
 * @param <T> Le type du modèle
 */
public interface InterfaceDAO<T> {
    Optional<T> trouverParId(UUID id);
    List<T> listerTout();
    boolean creer(T objet);
    boolean modifier(T objet);
    boolean supprimer(UUID id);
}
