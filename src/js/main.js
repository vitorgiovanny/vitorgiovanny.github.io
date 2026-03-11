import {fetchJson} from './jsonReader.js';
let jsonData = [];

function getDataPath(){
    return new URL('../Config/data.json', import.meta.url).pathname;
}

function normalizeTags(tags){
    if (Array.isArray(tags)) return tags.join(', ');
    return tags || '';
}

function getPostHrefByContext(id){
    const isPagesPath = window.location.pathname.includes('/src/Pages/');
    return isPagesPath ? `./Posts.html?id=${id}` : `./src/Pages/Posts.html?id=${id}`;
}

function createChallengeCard(data){
    return `
    <div class="post">
        <div class="headerPost">
            <div class="myChallenge">
                <h4 class="tiitleLink"><a href="${getPostHrefByContext(data.Id)}">${data.title}</a></h4>
                <span class="descriptionTitle">${data.descriptionTitle}</span><br>
                <b>Tags:</b> <span>${normalizeTags(data.tags)}</span><br>
                <div>${data.tagsDesafios || ''}</div>
                <div>Status: <span class="status-badge">${data.status}</span></div>
            </div>
        </div>
    </div>
    `;
}

function createLearningCard(data){
    const learningItems = (data.aprendizado || []).map(item => `<li>${item}</li>`).join('');
    return `
    <div class="post">
        <div class="headerPost">
            <div class="myChallenge">
                <h4 class="tiitleLink"><a href="${getPostHrefByContext(data.Id)}">${data.title}</a></h4>
                <span class="descriptionTitle">${data.descriptionTitle}</span>
                <div class="learning-list">
                    <b>Aprendizados:</b>
                    <ul>${learningItems || '<li>Registro de aprendizado em andamento.</li>'}</ul>
                </div>
            </div>
        </div>
    </div>
    `;
}

async function loadJsonData(){
    if (jsonData.length > 0) return jsonData;
    jsonData = await fetchJson(getDataPath());
    return jsonData;
}

async function renderList(containerId, cardFactory){
    const container = document.getElementById(containerId);
    if (!container) return;

    const data = await loadJsonData();
    if (!data || data.length === 0){
        container.innerHTML = '<p>Não foi possível carregar os dados no momento.</p>';
        return;
    }

    container.innerHTML = data.map(item => cardFactory(item)).join('');
}

export async function renderPostByQueryString(){
    const page = document.getElementById('post-id-json');
    if (!page) return;

    const search = new URLSearchParams(window.location.search);
    const id = Number(search.get('id'));
    const data = await loadJsonData();
    const model = data.find(post => Number(post.Id) === id);

    if (!model){
        page.innerHTML = '<p>Desafio não encontrado.</p>';
        return;
    }

    const learningItems = (model.aprendizado || []).map(item => `<li>${item}</li>`).join('');

    page.innerHTML = `
        <div class="post post-detail">
            <div class="headerPost">
                <div class="myChallenge">
                    <h1 class="tiitleLink">${model.title}</h1>
                    <p class="descriptionTitle">${model.description}</p>
                    <br>
                    <b>Tags:</b> <span>${normalizeTags(model.tags)}</span>
                    <div class="learning-list">
                        <b>Requisitos:</b>
                        <div>${model.requisitos || 'Sem requisitos cadastrados.'}</div>
                    </div>
                    <div class="learning-list">
                        <b>Aprendizado:</b>
                        <ul>${learningItems || '<li>Aprendizado ainda não informado.</li>'}</ul>
                    </div>
                    ${model.href ? `<p><a class="code-link" href="${model.href}" target="_blank">Ver código</a></p>` : ''}
                </div>
            </div>
        </div>
    `;
}

document.addEventListener('DOMContentLoaded', async () => {
    await renderList('post-data-json', createChallengeCard);
    await renderList('desafio-data-json', createChallengeCard);
    await renderList('aprendizado-data-json', createLearningCard);
    await renderPostByQueryString();
});