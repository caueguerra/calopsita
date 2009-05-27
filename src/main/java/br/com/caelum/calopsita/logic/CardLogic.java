package br.com.caelum.calopsita.logic;

import java.util.ArrayList;
import java.util.List;

import org.vraptor.annotations.Component;
import org.vraptor.annotations.InterceptedBy;

import br.com.caelum.calopsita.infra.interceptor.AuthenticationInterceptor;
import br.com.caelum.calopsita.infra.interceptor.AuthorizationInterceptor;
import br.com.caelum.calopsita.infra.interceptor.HibernateInterceptor;
import br.com.caelum.calopsita.model.Card;
import br.com.caelum.calopsita.model.Project;
import br.com.caelum.calopsita.model.User;
import br.com.caelum.calopsita.repository.CardRepository;
import br.com.caelum.calopsita.repository.ProjectRepository;

@Component
@InterceptedBy( { HibernateInterceptor.class, AuthenticationInterceptor.class, AuthorizationInterceptor.class })
public class CardLogic {

	private final CardRepository repository;
	private Project project;
	private final User currentUser;
	private final ProjectRepository projectRepository;
	private List<Card> cards;
	private Card card;

	public CardLogic(User user, CardRepository repository, ProjectRepository projectRepository) {
		this.currentUser = user;
		this.repository = repository;
		this.projectRepository = projectRepository;
	}

	public void save(Card card, Project project) {
		this.project = project;
		card.setProject(project);
		repository.add(card);
		this.cards = this.projectRepository.listCardsFrom(project);
	}

	public void saveSub(Card card) {
		repository.add(card);
		this.cards = this.repository.listSubcards(card.getParent());
		this.card = card.getParent();
		this.project = card.getProject();
	}

	public void edit(Card card) {
		this.card = this.repository.load(card);
		this.cards = this.repository.listSubcards(card);
	}

	public Card getCard() {
		return card;
	}

	public void update(Card card) {
		Card managedCard = repository.load(card);
		this.project = managedCard.getProject();
		managedCard.setName(card.getName());
		managedCard.setDescription(card.getDescription());
		repository.update(managedCard);
		this.cards = this.projectRepository.listCardsFrom(project);
	}

	public void prioritization(Project project) {
		this.project = this.projectRepository.get(project.getId());
		this.cards = this.projectRepository.listCardsFrom(project);
	}
	public void prioritize(Project project, List<Card> cards) {
		for (Card card : cards) {
			Card loaded = repository.load(card);
			loaded.setPriority(card.getPriority());
		}
		prioritization(project);
	}
	public List<Card> getCards() {
		return cards;
	}

	public List<List<Card>> getGroupedCards() {
		List<List<Card>> result = new ArrayList<List<Card>>();
		if (cards != null) {
			for (int i = maxPriority(cards); i >= 0; i--) {
				result.add(new ArrayList<Card>());
			}
			for (Card card : cards) {
				result.get(card.getPriority()).add(card);
			}
		}
		return result;
	}

	private int maxPriority(List<Card> cards) {
		int max = 0;
		for (Card card : cards) {
			if (card.getPriority() > max) {
				max = card.getPriority();
			}
		}
		return max;
	}

	public Project getProject() {
		return project;
	}

	public String delete(Card card, boolean deleteSubcards) {
		Card loaded = repository.load(card);
		this.project = loaded.getProject();
		if (this.project.getColaborators().contains(currentUser) || this.project.getOwner().equals(currentUser)) {
		    this.project = loaded.getProject();
	        if (deleteSubcards) {
	            for (Card sub : loaded.getSubcards()) {
	                repository.remove(sub);
	            }
	        } else {
	            for (Card sub : loaded.getSubcards()) {
	                sub.setParent(null);
	                repository.update(sub);
	            }
	        }
	        repository.remove(loaded);
	        return "ok";
		} else {
			return "invalid";
		}

	}
}