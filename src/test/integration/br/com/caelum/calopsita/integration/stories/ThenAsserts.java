package br.com.caelum.calopsita.integration.stories;

import static org.hamcrest.Matchers.not;
import static org.junit.Assert.assertThat;

import org.hamcrest.Description;
import org.hamcrest.Factory;
import org.hamcrest.Matcher;
import org.hamcrest.TypeSafeMatcher;

import br.com.caelum.seleniumdsl.Browser;
import br.com.caelum.seleniumdsl.ContentTag;

public class ThenAsserts {

    private final Browser browser;
    private String name;
	private String divName;

    public ThenAsserts(Browser browser) {
        this.browser = browser;
    }

    public void iMustBeLoggedInAs(String login) {
        ContentTag div = this.browser.currentPage().div("user");
        assertThat(div, containsString(login));
        assertThat(div, containsString("Logout"));
    }

    public void iShouldSeeTheError(String error) {
        assertThat(browser.currentPage().div("errors"), containsString(error));
    }

    public void iMustNotBeLoggedIn() {
        assertThat(this.browser.currentPage().div("user"), containsString("Login"));
    }

    public void iAmBackToLoginPage() {
        ContentTag div = this.browser.currentPage().div("login");
        assertThat(div, containsString("Login"));
        assertThat(div, containsString("Password"));
    }

    public ThenAsserts project(String projectName) {
        this.name = projectName;
        this.divName = "projects";
        return this;
    }

    public void appearsOnList() {
        assertThat(this.browser.currentPage().div(divName), containsString(name));
    }

	public void thisUserAppearsOnColaboratorsList(String userName) {
		assertThat(this.browser.currentPage().div("colaborators"), containsString(userName));
	}

    public void notAppearsOnList() {
        assertThat(this.browser.currentPage().div("projects"), not(containsString(name)));
    }

	public void iAmNotAllowedToSeeTheProject() {
		assertThat(this.browser.currentPage().div("index"), containsString("not allowed to see this project"));
	}

	public void appearsOnScreen() {
		assertThat(browser.currentPage().div("project"), containsString(name));
	}
	

	@Factory
	public static Matcher<ContentTag> containsString(final String string) {
		return new TypeSafeMatcher<ContentTag>() {
			private String innerHTML;
			@Override
			public boolean matchesSafely(ContentTag item) {
				innerHTML = item.innerHTML();
				return innerHTML.contains(string);
			}
			@Override
			public void describeTo(Description description) {
				description
					.appendText("a div containing '")
					.appendText(string)
					.appendText("'");
			}
		};
	}

	public ThenAsserts theStory(String storyName) {
		this.name = storyName;
		this.divName = "stories";
		return this;
	}

	public void hasDescription(String storyDescription) {
		assertThat(browser.currentPage().div("stories"), containsString(storyDescription));
	}

	public ThenAsserts theIteration(String iterationGoal) {
        this.name = iterationGoal;
        this.divName = "iterations";
        return this;
    }
}