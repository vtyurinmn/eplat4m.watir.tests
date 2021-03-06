require 'watir'
require 'watir-webdriver'

module Helpers

  ## ОБЩИЕ МЕТОДЫ

  def browser(browser)
      Watir.default_timeout = 90
      @browser = Watir::Browser.new(browser)
  end

  # аутентификация в платформе
  def authentication(host, username, password)
    @browser.goto(host)
    @browser.window.maximize
    @browser.text_field(id: 'UserName').set(username)
    @browser.text_field(id: 'passwordId').set(password)
    @browser.button(value: 'Войти').click
  end

  # сохраняемся и машем ручкой (при работе с источниками данных решения)
  def app_save_and_exit(whereto)
    @browser.link(href: /#{whereto}/).when_present.click
    @browser.button(value: 'Сохранить и перейти').when_present.click
    sleep(5)
  end

  # добавление ролей (используем меню Безопаность)
  def add_role(role_name)
    sleep(5)
    @browser.button(xpath: 'html/body/div[1]/div/div/div[4]/div/div/div/button').when_present.click #кнопка "Добавить"
    @browser.text_field(id: 'roleName').set(role_name)
    @browser.execute_script("$('#roleName').trigger('change')")
    @browser.button(value: 'Создать').click
    sleep(5)
    @browser.button(xpath: 'html/body/div[1]/div/div/div[4]/div/div/div/button').when_present.click #кнопка "Сохранить"
    @browser.link(href:'#security/roles/').when_present.click
    #вернуться на вкладку "Роли"
  end

  # делаем клевые фоточки
  def make_screenshot(filename)
    @browser.screenshot.save ("../shots/#{filename}.png")
  end

  ##ЗАЛЕПУХИ

  #ожидание пока не появится элемент
  def wait(element)
    until element.exists? && element.visible?
      sleep(1)
    end
  end

  #ожидаем пока кнопка не станет кликабельной
  def button_enabled(button_name)
    until @browser.execute_script("return $._data($('.btn.btn-panel:contains(\"#{button_name}\")').get(0),
'events').click != null")
      sleep(1)
      end
  end

  ## МЕТОДЫ ДЛЯ РАБОТЫ С РЕШЕНИЯМИ

  # создание нового решения
  def create_solution(solution_name, solution_description)
    @browser.link(text: 'Администрирование').when_present.click
    @browser.link(text: 'Решения').click
    @browser.button(title: 'Добавить').when_present.click
    @browser.text_field(id: 'solutionName').when_present.set(solution_name)
    @browser.textarea(id: 'solutionDescription').set(solution_description)
    @browser.execute_script("$('#solutionName').trigger('change')")
    @browser.button(value: 'Создать').click
  end

  ## МЕТОДЫ ДЛЯ РАБОТЫ С ПРИЛОЖЕНИЯМИ

  # создание нового приложения
  def add_application(app_name)
    @browser.link(href: /dataSources/).when_present.click
    @browser.button(title: 'Создать приложение').when_present.click
    @browser.text_field(id: 'applicationName').when_present.set(app_name)
    @browser.button(value: 'Создать').click
    sleep(5)
    @browser.link(href: /fields/).when_present.click
  end

  # добавление нового поля типа "Текст" в приложении
  def create_text_field(field_name, field_index)
    @browser.div(css: '.panel.panel-default.text-center', index: 0).when_present.click
    @browser.text_field(class: 'columnNameInput', index: field_index).set(field_name)
  end

  # добавление нового поля типа "Документ" в приложении
  def create_document_field(field_name, field_index)
    @browser.div(css: '.panel.panel-default.text-center', index: 7).when_present.click
    @browser.text_field(class: 'columnNameInput', index: field_index).set(field_name)
  end

  # добавление нового поля типа "Дата" в приложении
  def create_date_field(field_name, field_index)
    @browser.div(css: '.panel.panel-default.text-center', index: 4).when_present.click
    @browser.text_field(class: 'columnNameInput', index: field_index).set(field_name)
  end

  # добавление нового поля типа "Связь" в приложении
  def create_connection_field(field_name, field_index, app_name, conn_type)
    @browser.div(css: '.panel.panel-default.text-center', index: 8).when_present.click
    @browser.text_field(class: 'columnNameInput', index: field_index).set(field_name)
    @browser.link(class: 'link-button-grid', title: 'Настройки', index: field_index).click
    @browser.link(css: '.select2-choice.select2-default').when_present.click
    @browser.text_field(class: 'select2-input select2-focused').set(app_name)
    @browser.div(class: 'select2-result-label').click
    @browser.select_list.select(conn_type)
    @browser.button(value: 'Ok').click
  end

  # добавление нового поля типа "Состояние"
  def create_state_field(field_name, field_index)
    @browser.div(css: '.panel.panel-default.text-center', index: 3).when_present.click
    @browser.text_field(class: 'columnNameInput', index: field_index).set(field_name)
    @browser.link(class: 'link-button-grid', title: 'Настройки', index: field_index).click
    @browser.link(css: '.select2-choice.select2-default').when_present.click
    @browser.div(class: 'select2-result-label').when_present.click
    @browser.button(value: 'Ok').click
  end

  # добавление свойства "Имя объекта" для поля приложения типа "Текст"
  def set_name_for_link(field_index)
    @browser.link(class: 'link-button-grid', title: 'Настройки', index: field_index).click
    @browser.checkbox(id: 'useAsNameForLink').when_present.set
    @browser.button(value: 'Ok').click
  end

  # добавление свойства "Текущая дата" для поля приложения типа "Дата", переделать под разные значения
  def set_сurrent_date(field_index)
    @browser.link(class: 'link-button-grid', title: 'Настройки', index: field_index).click
    @browser.select_list(:id, 'defaultValue').when_present.select('Текущая дата')
    @browser.button(value: 'Ok').click
  end

  ## МЕТОДЫ ДЛЯ РАБОТЫ С ПРОВАЙДЕРАМИ ДАННЫХ

  # создание нового провайдера
  def add_provider(provider_name)
    wait(@browser.button(css: '.btn.btn-panel.btn-xs:nth-of-type(3)'))
    button_enabled('Создать провайдер данных')
    @browser.button(css: '.btn.btn-panel.btn-xs:nth-of-type(3)').click
    @browser.text_field(id: 'name').when_present.set(provider_name)
    @browser.button(value: 'Создать').click
  end

  # выбор связанного приложения
  def add_app(app_name)
    @browser.link(css: '.select2-choice.select2-default').when_present.click
    @browser.text_field(class: 'select2-input select2-focused').when_present.set(app_name)
    @browser.div(class: 'select2-result-label').when_present.click
  end

  # выбор дополнительного приложения
  def bond_app(bond_index)
    @browser.link(title: 'Добавить связь').when_present.click
    @browser.link(css: '.btn.btn-primary', index: bond_index).when_present.click
  end

  # переключить вкладку (c href)
  def inset_change_href(app_inset)
    @browser.link(href: app_inset).when_present.click
  end

  # переключить вкладку (по text)
  def inset_change(app_inset)
    @browser.link(text: app_inset).when_present.click
  end

  # переключить вкладку (по xpath)
  def inset_change_xpath(app_inset)
    @browser.link(xpath: app_inset).when_present.click
  end

  #	выбор полей из приложений
  def choose_field(field_index, field_name)
    @browser.button(value: 'Добавить поле').when_present.click
    @browser.div(id: /s2id_autogen/, index: field_index).when_present.click
    @browser.text_field(class: 'select2-input select2-focused').when_present.set(field_name)
    @browser.span(class: 'select2-match').when_present.click
  end

  #	выбор типа функции для поля
  def select_func(func_index, func_value)
    @browser.select_list(data_bind: /aggregateTypes/, index: func_index).select(func_value)
  end

  # добавление группы состояний
  def state_grout_set(state_name)
    @browser.button(css: '.btn.btn-panel.btn-xs').when_present.click
    @browser.text_field(id: 'stateGroupName').when_present.set(state_name)
    @browser.button(value: 'Создать').click
  end

  # добавление начального состояния
  def beg_state(state_name)
    sleep(5)
    @browser.button(title: 'Добавить').click
    @browser.text_field(id: 'stateName').when_present.set(state_name)
    @browser.checkbox(id: 'stateStart').set
    @browser.button(value: 'Создать').click
  end

  # добавление состояния
  def new_state(state_name)
    sleep(5)
    @browser.button(title: 'Добавить').click
    @browser.text_field(id: 'stateName').when_present.set(state_name)
    @browser.button(value: 'Создать').click
  end
  
  #добавление перехода между состояниями
  def state_trans(trans_index, trans_name)
    sleep(5)
    @browser.link(css: '.dx-link.link-button-grid', index: trans_index).click
    # переключаемся на "Редактор переходов"...
    @browser.link(xpath: 'html/body/div[1]/div/div/div[4]/div/section/div/div/div/div/ul/li[2]/a').when_present.click
    # ...и жмем кнопку "Добавить"
    @browser.button(xpath: 'html/body/div[1]/div/div/div[4]/div/div/div/button').when_present.click
    @browser.select_list(id: 'transition').when_present.select(trans_name)
    @browser.button(value: 'Добавить').click
  end

  def role_trans(role_name)
    sleep(5)
    # переключаемся на "Редактор переходов"...
    @browser.link(xpath: 'html/body/div[1]/div/div/div[4]/div/section/div/div/div/div/ul/li[3]/a').when_present.click
    # ...и жмем кнопку "Добавить"
    @browser.button(xpath: 'html/body/div[1]/div/div/div[4]/div/div/div/button[2]').when_present.click
    @browser.select_list(id: 'role').when_present.select(role_name)
    @browser.button(value: 'Добавить').click
  end

  def state_app(app_index, field_name, field_index)
    sleep(5)
    @browser.link(class: 'dx-link link-button-grid', title: 'Перейти', index: app_index).when_present.click
    @browser.link(href: /fields/).when_present.click
    create_state_field(field_name, field_index)
    @browser.button(css:'button.btn-panel:nth-child(1)').when_present.click
  end
end