package tr.biznet.bizzy.controller;

import com.google.gson.Gson;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attributes;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;
import javax.naming.ldap.LdapContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;
import tr.biznet.bizzy.domain.BizzyException;
import tr.biznet.bizzy.domain.BizzySecurityException;
import tr.biznet.bizzy.domain.DatabaseMessageSourceBase;
import tr.biznet.bizzy.service.aa.dao.UserDao;
import tr.biznet.bizzy.service.aa.domain.User;
import tr.biznet.bizzy.service.aa.domain.ChangePasswordModel;
import tr.biznet.bizzy.service.aa.domain.Group;
import tr.biznet.bizzy.service.aa.domain.Role;
import tr.biznet.bizzy.service.aa.domain.validator.ChangePasswordModelValidator;
import tr.biznet.bizzy.service.aa.domain.validator.GroupValidator;
import tr.biznet.bizzy.service.aa.service.UserService;
import tr.biznet.bizzy.service.customer.CustomerService;
import tr.biznet.bizzy.service.customer.domain.Customer;
import tr.biznet.bizzy.service.mail.MailService;
import tr.biznet.bizzy.taskengine.util.MessageUtil;
import tr.biznet.bizzy.ticket.entity.datatable.DatatableView;
import tr.biznet.bizzy.ticket.entity.datatable.DatatableViewLanguage;
import tr.biznet.bizzy.util.BizzyUtil;
import tr.biznet.bizzy.util.HttpUtil;
import tr.biznet.bizzy.util.RegexUtil;
import tr.biznet.bizzy.util.log.LogLevel;
import tr.biznet.bizzy.util.log.LoggerFactory;
import tr.biznet.bizzy.service.aa.domain.validator.UserValidator;
import tr.biznet.bizzy.service.aa.enums.UserTypeEnum;
import tr.biznet.bizzy.service.assetGroup.service.AssetGroupService;
import tr.biznet.bizzy.service.file.entity.ImageFile;
import tr.biznet.bizzy.service.file.enums.FileDataTypeEnum;
import tr.biznet.bizzy.service.file.service.FileService;
import tr.biznet.bizzy.service.scan.domain.AssetGroup;
import tr.biznet.bizzy.service.server.ServerService;
import tr.biznet.bizzy.service.server.domain.Server;
import tr.biznet.bizzy.service.server.enums.ServerType;
import tr.biznet.bizzy.ticket.entity.Ticket;
import tr.biznet.bizzy.ticket.entity.modal.Alert;
import tr.biznet.bizzy.ticket.service.TicketExternalService;
import tr.biznet.bizzy.util.BizzyGson;
import tr.biznet.bizzy.util.datatables.DataTablesRequest;
import tr.biznet.bizzy.util.datatables.DataTablesUtil;

/**
 * Kullanıcı ayarları sayfası
 *
 * @author aidikut
 */
@Controller
@RequestMapping("/user/")
public class UserController {

    private static final tr.biznet.bizzy.util.log.Logger logger = LoggerFactory.getLogger(UserController.class);

    @Autowired
    private UserService aaService;

    @Autowired
    private TicketExternalService ticketExternalService;

    @Autowired
    private CustomerService customerService;
    
    @Autowired
    private AssetGroupService assetGroupService;

    @Autowired
    private MailService mailService;

    @Autowired
    private DatabaseMessageSourceBase messageSource;

    @Autowired
    private ServerService serverService;

    @Autowired
    private FileService fileService;

    @Autowired
    private UserDao userDao;

    Gson gson = BizzyGson.createGsonSerializeNulls();

    @RequestMapping(value = "/settings.htm", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView settings(HttpServletRequest request, HttpServletResponse response, ChangePasswordModel changePasswordModel, BindingResult result, final RedirectAttributes redirectAttributes) {
        User user = HttpUtil.getUser();
        if (HttpUtil.isGet(request)) {
            ChangePasswordModel model = new ChangePasswordModel();
            model.setUsername(user.getUsername());
            ModelAndView mv = new ModelAndView();
            mv.addObject(model);
            return mv;
        } else if (HttpUtil.isPost(request)) {
            changePasswordModel.setUsername(user.getUsername());
            ChangePasswordModelValidator userModelValidator = new ChangePasswordModelValidator();
            userModelValidator.validate(changePasswordModel, result);
            if (result.hasErrors()) {
                ModelAndView mv = new ModelAndView();
                mv.addObject(changePasswordModel);
                return mv;
            }
            if (!aaService.isPasswordValid(changePasswordModel.getPassword(), user.getPassword())) {
                result.rejectValue("password", null, "Girilen parola geçerli değil.");
                ModelAndView mv = new ModelAndView();
                mv.addObject(changePasswordModel);
                return mv;
            }

            try {
                aaService.changePassword(user, changePasswordModel.getNewPassword());
                logger.log(LogLevel.INFO, "Kullanıcı şifre değiştirme işlemi başarılı.");
                redirectAttributes.addFlashAttribute("successMessage", "Parolanız başarıyla değiştirildi.");
            } catch (Exception ex) {
                logger.log(LogLevel.ERROR, "Kullanıcı şifre değiştirme işlemi başarısız.", ex);
                redirectAttributes.addFlashAttribute("error", "settings.password.error");
            }
            return HttpUtil.sendRedirect("settings.htm");
        }
        //POST veya GET harici çağrılmaması gerekir.
        return null;
    }

    @RequestMapping(value = "/rolesInfo.htm", method = {RequestMethod.GET})
    public ModelAndView rolesInfo(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView mv = new ModelAndView();
        return mv;
    }

    /**
     * ****************************customer**********************************************
     */
    @RequestMapping(value = "/listUsers.htm", method = {RequestMethod.GET})
    public ModelAndView listUsers(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView mv = new ModelAndView();
        User user = HttpUtil.getUser();
        String customerId = BizzyUtil.getCustomerIdByUser(user);
        List<Group> groups = aaService.getGroupsByCustomerId(customerId);

        List<User> searchUsers = aaService.getUsersByCustomerId(customerId);
        mv.addObject("searchUsers", searchUsers);

        mv.addObject("customers", customerService.getCustomers());
        mv.addObject("groups", groups);
        mv.addObject("customerId", customerId);
        mv.addObject("customerURLId", ServletRequestUtils.getStringParameter(request, "customerId", null));
        return mv;
    }

    //Ajax tarafından çağrılıyor.
    @RequestMapping(value = "/loadUsers.json", method = RequestMethod.POST, produces = HttpUtil.MIME_TYPE_JSON)
    @ResponseBody
    public String loadUsers(HttpServletRequest request, HttpServletResponse response) {
        User user = HttpUtil.getUser();
        List<Role> roles = Arrays.asList(user.getRole());
        String customerId;
        if (BizzyUtil.hasACustomerRole(user)) {
            customerId = BizzyUtil.getCustomerIdByUser(user);
        } else {
            customerId = ServletRequestUtils.getStringParameter(request, "customerId", null);
        }
        String searchUser = ServletRequestUtils.getStringParameter(request, "searchUsers", null);
        List<User> users = getUserListByCustomerIdAndRole(customerId,user,searchUser);
        
        Locale locale = RequestContextUtils.getLocale(request);
        DatatableView<List<User>> datatableView = new DatatableView<>();
        datatableView.setData(users);
        datatableView.setLanguage(new DatatableViewLanguage(locale));
        if (user.getRole().getRoleName().equals("ROLE_ADMIN") || user.getRole().getRoleName().equals("ROLE_PENTEST_ADMIN")) {
            datatableView.setColumnsWithParams("user", locale, "username", "userGroups.[, ].name", "enabled", "creationDate", "lastLoginDate", "role.roleName", "customer.companyName");
        }
        else{
            datatableView.setColumnsWithParams("user", locale, "username", "userGroups.[, ].name", "enabled", "creationDate", "lastLoginDate", "role.roleName");
        }
        datatableView.setOrder(Arrays.asList(Arrays.asList(0, "desc")));
        datatableView.setPaging(true);
        datatableView.setInfo(true);
        return DataTablesUtil.getResponse(datatableView, true);
    }
    
    //Ajax tarafından çağrılıyor.
    @RequestMapping(value = "/loadSavedUsers.json", method = RequestMethod.POST, produces = HttpUtil.MIME_TYPE_JSON)
    @ResponseBody
    public String loadSavedUsers(HttpServletRequest request, HttpServletResponse response) {
        String customerId = ServletRequestUtils.getStringParameter(request, "customerId", null);
        if(BizzyUtil.isEmpty(customerId)) {
            customerId = BizzyUtil.getCustomerIdByUser(HttpUtil.getUser());
        }
        List<User> userList = aaService.getUsersByCustomerId(customerId); // Bizzy kullanıcı listesi

        DataTablesRequest dataTablesRequest = DataTablesUtil.getRequest(request);
        int totalCount = userList.size();
        return DataTablesUtil.getResponse(dataTablesRequest.getDraw(), totalCount, totalCount, userList);
    }
    
    public List<User> getUserListByCustomerIdAndRole(String customerId,User user,String searchUser ){
        List<User> users = new ArrayList<>();
        if (user.getRole().getRoleName().equals("ROLE_ADMIN") || user.getRole().getRoleName().equals("ROLE_PENTEST_ADMIN")) {
            if (!BizzyUtil.isEmpty(customerId)) {
                for (String cstmr : customerId.split(",")) {
                    users.addAll(aaService.getUsersByCustomerId(cstmr));
                }
            }
            else{
                users = aaService.getHierarchicalUserList(user);
            }
        }
        else if(user.getRole().getRoleName().equals("ROLE_MANAGER") || user.getRole().getRoleName().equals("ROLE_COMPANY_MANAGER")){
            users = aaService.getUsersByCustomerIdEager(customerId);
        }
        if (!BizzyUtil.isEmpty(searchUser)) {
            for (int i = 0; i < users.size(); i++) {
                if (!(users.get(i).getUsername().contains(searchUser))) {
                    users.remove(i);
                    i--;
                }
            }
        }
        for(int i =0; i < users.size() ; i++ ){
            if (users.get(i).getCustomer() == null ){
                Customer customer = new Customer();
                customer.setCompanyName(" ");
                users.get(i).setCustomer(customer);
            }
        }
        return users;
    }
    
    @RequestMapping(value = "/listGroups.htm", method = {RequestMethod.GET})
    public ModelAndView listGroups(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView mv = new ModelAndView();
        User user = HttpUtil.getUser();
        String customerId = BizzyUtil.getCustomerIdByUser(user);
        mv.addObject("customerId", customerId);
        return mv;
    }

    //Ajax tarafından çağrılıyor.
    @RequestMapping(value = "/loadGroups.json", method = RequestMethod.POST, produces = HttpUtil.MIME_TYPE_JSON)
    @ResponseBody
    public String loadGroups(HttpServletRequest request, HttpServletResponse response) {
        String customerId = ServletRequestUtils.getStringParameter(request, "customerId", "");
        if (BizzyUtil.isEmpty(customerId)) {
            User user = HttpUtil.getUser();
            customerId = BizzyUtil.getCustomerIdByUser(user);
        }
        List<Group> groups = aaService.getGroupsByCustomerId(customerId);
        Locale locale = RequestContextUtils.getLocale(request);
        DatatableView<List<Group>> datatableView = new DatatableView<>();
        datatableView.setData(groups);
        datatableView.setLanguage(new DatatableViewLanguage(locale));
        datatableView.setColumnsWithParams("group", locale, "name", "parentGroupName", "description", "createDate", "createUser.username");
        datatableView.setOrder(Arrays.asList(Arrays.asList(0, "desc")));
        datatableView.setPaging(true);
        datatableView.setInfo(true);
        return DataTablesUtil.getResponse(datatableView, true);
    }

    @RequestMapping(value = "/addGroup.htm", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView addGroup(HttpServletRequest request, HttpServletResponse response) {
        String action = ServletRequestUtils.getStringParameter(request, "action", "new");
        String customerId = ServletRequestUtils.getStringParameter(request, "customerId", "");
        User user = HttpUtil.getUser();
        if (BizzyUtil.hasACustomerRole(user)) {
            customerId = BizzyUtil.getCustomerIdByUser(user);
        }
        ModelAndView mv = new ModelAndView();
        mv.addObject("customerId", customerId);
        if (action.equals("update")) {
            String groupId = ServletRequestUtils.getStringParameter(request, "id", null);
            Group group = aaService.getGroupByIdAndCustomerId(customerId, groupId);
            if(!BizzyUtil.isEmpty(group.getParentGroupId())){
                group.setParentGroupName(aaService.getGroupById(group.getParentGroupId()).getName());
            }
            if (group == null) {
                return HttpUtil.sendRedirect("/error/userForbidden.htm");
            }
            mv.addObject(group);
        } else {
            mv.addObject(new Group());
        }
        mv.addObject("action", action);
        return mv;
    }

    /**
     * Kullanıcı ekleme ve güncelleme sayfası
     *
     * @param request
     * @param response
     * @return mv
     * @throws BizzySecurityException
     */
    @RequestMapping(value = "/addUser.htm", method = {RequestMethod.GET})
    public ModelAndView addUser(HttpServletRequest request, HttpServletResponse response) throws BizzySecurityException {
        String action = ServletRequestUtils.getStringParameter(request, "action", "new");
        String customerId = ServletRequestUtils.getStringParameter(request, "customerId", null);
        String groupId = ServletRequestUtils.getStringParameter(request, "groupId", null);
        String customerURLId = ServletRequestUtils.getStringParameter(request, "customerURLId", null);
        if (!BizzyUtil.isEmpty(customerURLId)) {
            customerId = ServletRequestUtils.getStringParameter(request, "customerURLId", null);
        }
        String userId = ServletRequestUtils.getStringParameter(request, "userId", null);
        User user = HttpUtil.getUser();
        if (BizzyUtil.hasACustomerRole(user)) {
            if (BizzyUtil.isUserAuthorizedForCustomer(user, customerId)) {
                customerId = BizzyUtil.getCustomerIdByUser(user);
            } else {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return HttpUtil.sendRedirect("../error/userForbidden.htm");
            }
        }
        List<Group> groupList = aaService.getGroupsByCustomerId(customerId);
        ModelAndView mv = new ModelAndView();
        List<AssetGroup> assetGroupList = customerService.getAssetGroups(null, customerId);
        mv.addObject("assetGroupList", assetGroupList);
        if (!BizzyUtil.isEmpty(customerURLId)) {
            mv.addObject("roles", aaService.getRolesOnlyCustomer(HttpUtil.getUser().getUserId()));
        } else {
            mv.addObject("roles", aaService.getRoles(HttpUtil.getUser().getUserId()));
        }
        mv.addObject("customerId", customerId);
        mv.addObject("types", UserTypeEnum.values());
        List<Server> adServers = serverService.getServerByType(ServerType.ACTIVE_DIRECTORY, customerId);
        if (adServers.size() > 0) {
            mv.addObject("adServerExist", true);
        } else {
            mv.addObject("adServerExist", false);
        }
        if (action.equals("update")) {
            user = aaService.getUserByIdEager(userId);
            user.setAssetGroupIdSet(userDao.getUserAssetGroupRelation(user.getUserId()));
            if (user.getRole() != null) {
                user.setRoleId(user.getRole().getId());
            }
            if (user.getOwnedGroup() != null) {
                Set<String> groups = new HashSet<>();
                for (Group ids : user.getOwnedGroup()) {
                    groups.add(ids.getId());
                }
                user.setOwnedGroupId(groups);
            }
            mv.addObject(user);

            mv.addObject("hiddenUserId", user.getUserId());
            mv.addObject("selectedGroups", user.getUserGroups());
        } else {
            User newUser = new User();
            newUser.setEnabled(true);
            mv.addObject(newUser);
            if (groupId != null) {
                mv.addObject("selectedGroupId", groupId);
            }
        }
        mv.addObject("groupList", groupList);
        mv.addObject("action", action);
        return mv;
    }

    /**
     * user ekleme istenilginde form nesnesi serializable bu foksiyona
     * gonderilir
     *
     * @param request
     * @param response
     * @param user
     * @param bindingResult
     * @return
     */
    @RequestMapping(value = "/addUser.form", method = {RequestMethod.POST}, produces = HttpUtil.MIME_TYPE_JSON)
    @ResponseBody
    public String addUserForm(HttpServletRequest request, HttpServletResponse response, @Valid User user, BindingResult bindingResult) {
        Locale locale = RequestContextUtils.getLocale(request);
        if (!bindingResult.hasErrors()) {
            String passwordCheckbox = ServletRequestUtils.getStringParameter(request, "passwordCheckbox", "");
            String controlPassword = checkPassword(request, locale);
            String controlUsername = checkUsername(request, user.getUsername(), locale);

            String result = checkUserRole(user, locale);
            if(!result.equals("correct")){
                return result;
            }

            if (user.getRoleId().equals("5") && user.getOwnedGroupId() != null) {
                for (String ownedGroupId : user.getOwnedGroupId()) {
                    if (!user.getGroupIdSet().contains(ownedGroupId)) {
                        Map error = new HashMap();
                        error.put("flied", "groupAdminError");
                        error.put("error", MessageUtil.getLocaleMessage(locale, "addUser.groupAdminAssignError"));
                        return gson.toJson(error);
                    }
                }
            }
            if (controlPassword == null && controlUsername == null) {
                String customerId = ServletRequestUtils.getStringParameter(request, "customerId", "");
                if (BizzyUtil.hasACustomerRole(HttpUtil.getUser())) {
                    if (BizzyUtil.isUserAuthorizedForCustomer(HttpUtil.getUser(), customerId)) {
                        customerId = BizzyUtil.getCustomerIdByUser(HttpUtil.getUser());
                    } else {
                        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        return "{}";
                    }
                    if (user.getRoleId() != null) {
                        Set<Role> roles = (Set<Role>) aaService.getRolesOnlyCustomer(HttpUtil.getUser().getUserId());                       
                        if (!roles.stream().filter(o -> o.getId().equals(user.getRoleId())).findFirst().isPresent()) {
                            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                            return "{}";
                        }
                    }
                    if (user.getGroupIdSet() != null && !user.getGroupIdSet().isEmpty()) {
                        if (aaService.getGroupsByIdListAndCustomerId(customerId, user.getGroupIdSet().stream().toArray(String[]::new)).size()
                                != user.getGroupIdSet().size()) {
                            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                            return "{}";
                        }
                    }
                    if (user.getOwnedGroupId() != null && !user.getOwnedGroupId().isEmpty()) {
                        if (aaService.getGroupsByIdListAndCustomerId(customerId, user.getOwnedGroupId().stream().toArray(String[]::new)).size()
                                != user.getOwnedGroupId().size()) {
                            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                            return "{}";
                        }
                    }
                    if (user.getAssetGroupIdSet() != null && !user.getAssetGroupIdSet().isEmpty()) {
                        if (assetGroupService.getAssetGroupsByIdListAndCustomerId(customerId, user.getAssetGroupIdSet()).size()
                                != user.getAssetGroupIdSet().size()) {
                            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                            return "{}";
                        }
                    }
                } else {
                    Set<Role> roles;                       
                    if (BizzyUtil.isEmpty(customerId)) {
                        roles = aaService.getRoles(HttpUtil.getUser().getUserId());
                    } else {
                        roles = (Set<Role>) aaService.getRolesOnlyCustomer(HttpUtil.getUser().getUserId());
                    }
                    if (!roles.stream().filter(o -> o.getId().equals(user.getRoleId())).findFirst().isPresent()) {
                        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        return "{}";
                    }
                }
                Customer customer = customerService.getCustomer(customerId);
                user.setCustomer(customer);
                String saveResult = aaService.saveUser(user, customerId);

                switch (saveResult) {
                    case "limit.error": {
                        Map error = new HashMap();
                        error.put("flied", "genericError");
                        error.put("error", MessageUtil.getLocaleMessage(locale, "limit.service.count"));
                        logger.log(LogLevel.INFO, "Kullanıcı limiti yetersiz, ekleme işlemi : " + user.getUsername());
                        return gson.toJson(error);
                    }
                    case "registered.error": {
                        Map error = new HashMap();
                        error.put("flied", "genericError");
                        error.put("error", MessageUtil.getLocaleMessage(locale, "userValidator.userRegistered"));
                        logger.log(LogLevel.INFO, "Kullanıcı adı önceden eklenmiş, ekleme işlemi : " + user.getUsername());
                        return gson.toJson(error);
                    }
                    default:
                        user.setUserId(saveResult);
                        logger.log(LogLevel.INFO, "Kullanıcı ekleme işlemi başarılı : " + user.getUsername());
                        //Kullanıcıya hoş geldin mailinin gönderilmesi  
                        mailService.sendUserWelcomeMail(user);
                        if (BizzyUtil.isEmpty(passwordCheckbox)) {
                            if (user.getUserType() == null || user.getUserType().equals("BIZZY")) {
                                // LDAP sunucusu yoktur. User tipi seçeneği gözükmeyeceği için değer de döndürülmez.
                                mailService.sendFirstPasswordMail(user);
                            }
                        }
                        break;
                }
            } else {
                return controlPassword != null ? controlPassword : controlUsername;
            }
        }
        return "{}";
    }

    /**
     * user guncellemede istenilginde form nesnesi serializable bu foksiyona
     * gonderilir
     *
     * @param request
     * @param response
     * @param user
     * @param bindingResult
     * @return
     */
    @RequestMapping(value = "/updateUser.form", method = {RequestMethod.GET, RequestMethod.POST}, produces = HttpUtil.MIME_TYPE_JSON)
    @ResponseBody
    public String updateUserForm(HttpServletRequest request, HttpServletResponse response, @Valid User user, BindingResult bindingResult) {
        Locale locale = RequestContextUtils.getLocale(request);
        if (!bindingResult.hasErrors()) {
            String controlPassword = checkPassword(request, locale);
            String controlUsername = checkUsername(request, user.getUsername(), locale);
            
            String result = checkUserRole(user, locale);
            if(!result.equals("correct")){
                return result;
            }
            
            if (user.getOwnedGroupId() == null) {
                aaService.deleteGroupAdmin(user.getUserId());
            }

            if (user.getRoleId().equals("5") && user.getOwnedGroupId() != null) {
                for (String ownedGroupId : user.getOwnedGroupId()) {
                    if (!user.getGroupIdSet().contains(ownedGroupId)) {
                        Map error = new HashMap();
                        error.put("flied", "groupAdminError");
                        error.put("error", MessageUtil.getLocaleMessage(locale, "addUser.groupAdminAssignError"));
                        return gson.toJson(error);
                    }
                }
            }
            if (controlPassword == null && controlUsername == null) {
                String customerId = ServletRequestUtils.getStringParameter(request, "customerId", "");
                if (BizzyUtil.hasACustomerRole(HttpUtil.getUser())) {
                    if (!BizzyUtil.isUserAuthorizedForCustomer(HttpUtil.getUser(), customerId)) {
                        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        return "{}";
                    }
                    if (aaService.getUserByIdAndCustomerId(customerId, user.getUserId()) == null) {
                        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        return "{}";
                    }
                    if (user.getRoleId() != null) {
                        Set<Role> roles = (Set<Role>) aaService.getRolesOnlyCustomer(HttpUtil.getUser().getUserId());                       
                        if (!roles.stream().filter(o -> o.getId().equals(user.getRoleId())).findFirst().isPresent()) {
                            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                            return "{}";
                        }
                    }
                    if (user.getGroupIdSet() != null && !user.getGroupIdSet().isEmpty()) {
                        if (aaService.getGroupsByIdListAndCustomerId(customerId, user.getGroupIdSet().stream().toArray(String[]::new)).size()
                                != user.getGroupIdSet().size()) {
                            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                            return "{}";
                        }
                    }
                    if (user.getOwnedGroupId() != null && !user.getOwnedGroupId().isEmpty()) {
                        if (aaService.getGroupsByIdListAndCustomerId(customerId, user.getOwnedGroupId().stream().toArray(String[]::new)).size()
                                != user.getOwnedGroupId().size()) {
                            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                            return "{}";
                        }
                    }
                    if (user.getAssetGroupIdSet() != null && !user.getAssetGroupIdSet().isEmpty()) {
                        if (assetGroupService.getAssetGroupsByIdListAndCustomerId(customerId, user.getAssetGroupIdSet()).size()
                                != user.getAssetGroupIdSet().size()) {
                            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                            return "{}";
                        }
                    }
                } else {
                    Set<Role> roles;                       
                    if (BizzyUtil.isEmpty(customerId)) {
                        roles = aaService.getRoles(HttpUtil.getUser().getUserId());
                    } else {
                        roles = (Set<Role>) aaService.getRolesOnlyCustomer(HttpUtil.getUser().getUserId());
                    }
                    if (!roles.stream().filter(o -> o.getId().equals(user.getRoleId())).findFirst().isPresent()) {
                        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        return "{}";
                    }
                }
                User old = aaService.getUserById(user.getUserId());
                //Değişiklik loglamaları
                if (!old.getUsername().equals(user.getUsername())) {
                    logger.log(LogLevel.INFO, "Kullanıcı kullanıcı adı değişikliği, Kullanıcı adı: " + user.getUsername()
                            + " Eski Kullanıcı adı: " + old.getUsername());
                }
                if (!old.getRole().getId().equals(user.getRoleId())) {
                    logger.log(LogLevel.INFO, "Kullanıcı rol değişikliği, Kullanıcı adı: " + user.getUsername()
                            + " Eski rol id: " + old.getRole().getId() + " Yeni rol id: " + user.getRoleId());
                }
                if (!BizzyUtil.isEmpty(user.getPassword())) {
                    logger.log(LogLevel.INFO, "Kullanıcı şifre değişikliği, Kullanıcı adı: " + user.getUsername());
                }

                aaService.updateUser(user, true);
                //Kullanıcının rolü veya şifresi değişebileceği için oturumunu sonlandırmamız gerekiyor.
                aaService.expireUserSessions(user.getUsername());
                logger.log(LogLevel.INFO, "Kullanıcı güncelleme işlemi başarılı.");
                return "{}";
            } else {
                return controlPassword != null ? controlPassword : controlUsername;
            }
        }

        return "{}";
    }

    private String checkPassword(HttpServletRequest request, Locale locale) {
        String password = ServletRequestUtils.getStringParameter(request, "password", "");
        if (!BizzyUtil.isEmpty(password)) {
            Map error = new HashMap();
            error.put("flied", "passwordError");
            if (password == null || password.trim().isEmpty()) {
                error.put("error", MessageUtil.getLocaleMessage(locale, "userValidator.emptyPassword"));
                return gson.toJson(error);
            } else {
                if (password.length() > 20 || password.length() < 8) {
                    error.put("error", MessageUtil.getLocaleMessage(locale, "userValidator.badLengthPassword"));
                    return gson.toJson(error);
                } else {
                    if (!RegexUtil.isPassword(password)) {
                        error.put("error", MessageUtil.getLocaleMessage(locale, "userValidator.badPassword"));
                        return gson.toJson(error);
                    } else {
                        if (!RegexUtil.isPasswordSecured(password)) {
                            error.put("error", MessageUtil.getLocaleMessage(locale, "userValidator.notSecuredPassword"));
                            return gson.toJson(error);
                        }
                    }
                }
            }
        }
        return null;
    }

    private String checkUsername(HttpServletRequest request, String userName, Locale locale) {
        String hiddenUserId = ServletRequestUtils.getStringParameter(request, "hiddenUserId", null);
        if (!BizzyUtil.isEmpty(hiddenUserId)) {
            User oldUser = aaService.getUserById(hiddenUserId);
            if (!oldUser.getUsername().equals(userName)) {
                return checkUsername(userName, locale);
            }
        } else {

            return checkUsername(userName, locale);
        }
        return null;
    }

    private String checkUsername(String userName, Locale locale) {
        if (aaService.getUserByUsernameCount(userName) > 0) {
            User user = aaService.getUser(userName, true);
            String userRole = user.getRole().getRoleName();
            if (userRole.equals("ROLE_ADMIN") || userRole.equals("ROLE_PENTEST_ADMIN") || userRole.equals("ROLE_PENTEST_USER")) {
                Map error = new HashMap();
                error.put("flied", "usernameError");
                error.put("error", MessageUtil.getLocaleMessage(locale, "userValidator.usernameRegistered") + MessageUtil.getLocaleMessage(locale, "userValidator.userRole") + userRole);
                return gson.toJson(error);
            } else {
                Map error = new HashMap();
                error.put("flied", "usernameError");
                error.put("error", MessageUtil.getLocaleMessage(locale, "userValidator.usernameRegistered"));
                return gson.toJson(error);
            }
        }
        return null;
    }

    /**
     * group ekleme istenilginde form nesnesi serializable bu foksiyona
     * gonderilir
     */
    @RequestMapping(value = "/addGroup.form", method = {RequestMethod.GET, RequestMethod.POST},produces = HttpUtil.MIME_TYPE_JSON)
    @ResponseBody
    public String addGroupFrom(HttpServletRequest request, HttpServletResponse response, Group group, BindingResult result) {
        String customerId = ServletRequestUtils.getStringParameter(request, "customerId", "");
        User user = HttpUtil.getUser();
        if (BizzyUtil.isUserAuthorizedForCustomer(user, customerId)) {
            customerId = BizzyUtil.getCustomerIdByUser(user);
        } else {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            
        }
        GroupValidator groupValidator = new GroupValidator();
        groupValidator.validate(group, result);
        if(result.hasErrors()){
            return "{\"message\":\"Fail\"}";
        }
        Customer customer = customerService.getCustomer(customerId);
        group.setCustomer(customer);
        aaService.saveGroup(group);
        return "{\"message\":\"Success\"}";
    }

    /**
     * group guncellemede istenilginde form nesnesi serializable bu foksiyona
     * gonderilir
     */
    @RequestMapping(value = "/updateGroup.form", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public void updateGroupFrom(HttpServletRequest request, HttpServletResponse response, Group group) throws IOException {
        User user = HttpUtil.getUser();
        if (BizzyUtil.isUserAuthorizedForCustomer(user, group.getCustomerId())) {
            group.setCustomerId(BizzyUtil.getCustomerIdByUser(user));
        } else {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        if (aaService.getGroupByIdAndCustomerId(group.getCustomerId(), group.getId()) == null) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        aaService.updateGroup(group);
    }

    //Ajax tarafından çağrılıyor.
    @RequestMapping(value = "/deleteUser.json", method = RequestMethod.POST, produces = HttpUtil.MIME_TYPE_JSON)
    @ResponseBody
    public String deleteUser(HttpServletRequest request, HttpServletResponse response) {
        String userId = ServletRequestUtils.getStringParameter(request, "userId", null);
        Locale locale = RequestContextUtils.getLocale(request);
        if (userId != null) {
            User user = aaService.getUserById(userId);
            if(BizzyUtil.hasACustomerRole(HttpUtil.getUser())) {
                String customerId = BizzyUtil.getCustomerIdByUser(HttpUtil.getUser());
                if (!BizzyUtil.isEmpty(customerId) && !customerId.equals(BizzyUtil.getCustomerIdByUser(user))) {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    return "{}";
                }
            }
            String message = checkDeleteAssignee(userId, locale); //Kullanıcıya atanmış ticket varsa silemesin.
            if (message.equals("Assignee can be deleted.")) {
                aaService.deleteUser(userId);
                logger.log(LogLevel.INFO, "Kullanıcı silme işlemi başarılı: " + user.getUsername());
            } else {
                return gson.toJson(new Alert(message));
            }
        }
        return gson.toJson("");
    }

    //Ajax tarafından çağrılıyor.
    @RequestMapping(value = "/deleteGroup.json", method = RequestMethod.POST, produces = HttpUtil.MIME_TYPE_JSON)
    @ResponseBody
    @ResponseStatus(value = HttpStatus.OK)
    public String deleteGroup(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        Locale locale = RequestContextUtils.getLocale(request);
        if (id != null) {
            String message = checkDeleteAssignee(id, locale); //Gruba atanmış ticket varsa silemesin.
            if (message.equals("Assignee can be deleted.")) {
                aaService.deleteGroup(id);
                logger.log(LogLevel.INFO, "Grup silme işlemi başarılı: Group ID" + id);
            } else {
                return gson.toJson(new Alert(message));
            }
        }
        return gson.toJson("");
    }

    private String checkDeleteAssignee(String assigneeId, Locale locale) {
        //Ticketları durumlarına göre alıp eğer sorumlu üzerinde zafiyet varsa alert modalda uyarı olarak verdik.
        List<Ticket> openTickets = ticketExternalService.getTicketsByAssigneeIdAndStatus(assigneeId, "1");
        List<Ticket> closedTickets = ticketExternalService.getTicketsByAssigneeIdAndStatus(assigneeId, "2");
        List<Ticket> riskAcceptedTickets = ticketExternalService.getTicketsByAssigneeIdAndStatus(assigneeId, "3");
        List<Ticket> recheckTickets = ticketExternalService.getTicketsByAssigneeIdAndStatus(assigneeId, "4");
        List<Ticket> onHoldTickets = ticketExternalService.getTicketsByAssigneeIdAndStatus(assigneeId, "5");
        List<Ticket> inProgressTickets = ticketExternalService.getTicketsByAssigneeIdAndStatus(assigneeId, "6");
        List<Ticket> falsePositiveTickets = ticketExternalService.getTicketsByAssigneeIdAndStatus(assigneeId, "7");

        if (openTickets.isEmpty() && closedTickets.isEmpty() && riskAcceptedTickets.isEmpty()
                && recheckTickets.isEmpty() && onHoldTickets.isEmpty() && inProgressTickets.isEmpty()
                && falsePositiveTickets.isEmpty()) {
            return "Assignee can be deleted.";
        } else {
            String newLine = "</br>";
            String message = messageSource.getMessage("listUsers.deleteAssignee1", locale);
            message += newLine;
            message += newLine;
            if (!openTickets.isEmpty()) {
                message += openTickets.size() + ": " + messageSource.getMessage("genericdb.OPEN", locale) + newLine;
            }
            if (!closedTickets.isEmpty()) {
                message += closedTickets.size() + ": " + messageSource.getMessage("genericdb.CLOSED", locale) + newLine;
            }
            if (!riskAcceptedTickets.isEmpty()) {
                message += riskAcceptedTickets.size() + ": " + messageSource.getMessage("genericdb.RISK_ACCEPTED", locale) + newLine;
            }
            if (!recheckTickets.isEmpty()) {
                message += recheckTickets.size() + ": " + messageSource.getMessage("genericdb.RECHECK", locale) + newLine;
            }
            if (!onHoldTickets.isEmpty()) {
                message += onHoldTickets.size() + ": " + messageSource.getMessage("genericdb.ON_HOLD", locale) + newLine;
            }
            if (!inProgressTickets.isEmpty()) {
                message += inProgressTickets.size() + ": " + messageSource.getMessage("genericdb.IN_PROGRESS", locale) + newLine;
            }
            if (!falsePositiveTickets.isEmpty()) {
                message += falsePositiveTickets.size() + ": " + messageSource.getMessage("genericdb.FALSE_POSITIVE", locale) + newLine;
            }
            message += newLine;
            message += messageSource.getMessage("listUsers.deleteAssignee2", locale);
            return message;
        }

    }

    //Kullanıcıların eski grup ilişkilerini silerek, seçilen gruplar ile ilişkilendirir.
    @RequestMapping(value = "/assignUsersToGroups.json", method = RequestMethod.POST, produces = HttpUtil.MIME_TYPE_JSON)
    @ResponseBody
    public void assignUsersToGroups(HttpServletRequest request, HttpServletResponse response) {
        User user = HttpUtil.getUser();
        String[] userIds = ServletRequestUtils.getStringParameters(request, "userIds[]");
        String[] groupIds = ServletRequestUtils.getStringParameters(request, "groupIds[]");
        if (userIds.length > 0 && groupIds.length > 0) {
            for(String userId: userIds) {
                if (aaService.getUserByIdAndCustomerId(BizzyUtil.getCustomerIdByUser(user), userId) == null) {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
            }
            for(String groupId: groupIds) {
                if (aaService.getGroupByIdAndCustomerId(BizzyUtil.getCustomerIdByUser(user), groupId) == null) {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
            }
            aaService.assignUsersToGroups(userIds, groupIds);
            logger.log(LogLevel.INFO, "Kullanıcı grubu atama işlemi başarılı.");
        }
    }

    //Ajax tarafından çağrılıyor.
    @RequestMapping(value = "/updateAccountStatus.json", method = RequestMethod.POST, produces = HttpUtil.MIME_TYPE_JSON)
    @ResponseBody
    public String updateAccountStatus(HttpServletRequest request, HttpServletResponse response) throws BizzyException {
        String userId = ServletRequestUtils.getStringParameter(request, "userId", null);
        boolean status = ServletRequestUtils.getBooleanParameter(request, "status", false);
        User user = aaService.getUserById(userId);

        User sessionUser = HttpUtil.getUser();
        if (BizzyUtil.hasACustomerRole(sessionUser)) {
            String customerId = BizzyUtil.getCustomerIdByUser(user);
            List<User> users = aaService.getUsersByCustomerId(customerId);
            boolean isUser = false;
            for (User usr : users) {
                if (usr.getUserId().equals(userId)) {
                    isUser = true;
                    break;
                }
            }
            if (!isUser) {
                logger.log(LogLevel.ERROR, "Yetkisiz hesap dondurma işlemi ! UserId: " + userId);
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return "{}";
            }
        }

        if (userId != null) {
            try {
                user.setEnabled(status);
                aaService.updateUserStatus(user); //Aktiflik durumu güncelleme
                logger.log(LogLevel.INFO, user.getUsername() + " kullanıcısı hesap aktiflik durumu güncellendi. Aktiflik durumu: " + status);
            } catch (Exception ex) {
                logger.log(LogLevel.ERROR, userId + " id'li kullanıcı için hesap aktiflik durumu güncelleme işlemi başarısız.", ex);
                throw new BizzyException(userId + " id'li kullanıcı için hesap aktiflik durumu güncelleme işlemi başarısız.", ex);
            }
        }
        return "{}";
    }

    @RequestMapping(value = "/editUser.htm", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView addUser(HttpServletRequest request, HttpServletResponse response, User user, BindingResult result) {
        if (HttpUtil.isGet(request)) {
            ModelAndView mv = new ModelAndView();
            user = aaService.getUserById(HttpUtil.getUser().getUserId());
            user.setPassword(null);
            mv.addObject(user);
            return mv;
        } else if (HttpUtil.isPost(request)) {
            if (!HttpUtil.getUser().getUserId().equals(user.getUserId())) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return HttpUtil.sendRedirect("../error/userForbidden.htm");
            }
            UserValidator userValidator = new UserValidator();
            userValidator.validate(user, result);
            // User Id manipule edilmesin diye sessiondan aldık. 
            // Sessiondan sadece id bilgisini alıyoruz diğer bilgiler değişebileceği için db'den çektik.
            if (result.hasErrors()) {
                ModelAndView mv = new ModelAndView();
                user.setPassword(null);
                mv.addObject(user);
                return mv;
            }
            String customerId = BizzyUtil.getCustomerIdByUser(HttpUtil.getUser());
            try {
                if (!BizzyUtil.isEmpty(user.getFileId())) {
                    if(!BizzyUtil.isEmpty(customerId)){
                        ImageFile file=fileService.getImageFileByKeyAndCustomerId(customerId,user.getFileId());
                        List<ImageFile> filelist = fileService.getImageFileListByDataTypeAndTableIdAndCustomerIdWithoutData(customerId,user.getUserId(),FileDataTypeEnum.PROFILEPHOTO.getType());
                        for(ImageFile iFile:filelist){
                            if(iFile.getImageFileId().equals(file.getImageFileId()))
                                continue;
                            else
                                fileService.imageDeleteByKey(iFile.getImageFileId());
                        }
                        fileService.updateImageFileTableIdByFileIdAndCustomerId(customerId, file.getImageFileId(), user.getUserId());
                        request.getSession().setAttribute("profilePhoto", "data:image/png;base64," + file.getTextData());
                    }
                    else{
                        ImageFile file=fileService.getImageFileByKey(user.getFileId());
                        List<ImageFile> filelist = fileService.getImageFileListByDataTypeAndTableIdWithoutData(user.getUserId(),FileDataTypeEnum.PROFILEPHOTO.getType());
                        for(ImageFile iFile:filelist){
                            if(iFile.getImageFileId().equals(file.getImageFileId()))
                                continue;
                            else
                                fileService.imageDeleteByKey(iFile.getImageFileId());
                        }
                        fileService.updateImageFileTableIdByFileId(file.getImageFileId(),user.getUserId());
                        request.getSession().setAttribute("profilePhoto", "data:image/png;base64," + file.getTextData());
                    }
                    
                }
                else{
                   List<ImageFile> filelist=new ArrayList(); 
                    if(!BizzyUtil.isEmpty(customerId)){
                       filelist = fileService.getImageFileListByDataTypeAndTableIdAndCustomerIdWithoutData(customerId,user.getUserId(),FileDataTypeEnum.PROFILEPHOTO.getType());
                    }
                    else{
                        filelist = fileService.getImageFileListByDataTypeAndTableIdWithoutData(user.getUserId(),FileDataTypeEnum.PROFILEPHOTO.getType());
                    }
                    for(ImageFile iFile:filelist){
                        fileService.imageDeleteByKey(iFile.getImageFileId());
                    }
                    request.getSession().setAttribute("profilePhoto", "");
                    user.setFileId(null);
                }
                aaService.editUser(user);
                logger.log(LogLevel.INFO, "Kullanıcı bilgileri güncellendi: " + user.getUsername());
            } catch (Exception ex) {
                logger.log(LogLevel.ERROR, "Kullanıcı bilgileri güncellenirken hata oluştu.", ex);
            }
            
            return HttpUtil.sendRedirect("../dashboard/index.htm");
        }
        //POST ve GET harici çağrılmaması lazım.
        return null;
    }

    //Ajax tarafından çağrılıyor.
    @RequestMapping(value = "sendResetPasswordMail.json", method = RequestMethod.POST, produces = HttpUtil.MIME_TYPE_JSON)
    @ResponseBody
    public String sendResetPasswordMail(HttpServletRequest request, HttpServletResponse response) throws BizzyException {
        String userId = ServletRequestUtils.getStringParameter(request, "userId", null);
        if (userId != null) {
            try {
                User user = aaService.getUserById(userId);
                if(BizzyUtil.hasACustomerRole(HttpUtil.getUser())) {
                    String customerId = BizzyUtil.getCustomerIdByUser(HttpUtil.getUser());
                    if (!BizzyUtil.isEmpty(customerId) && !customerId.equals(BizzyUtil.getCustomerIdByUser(user))) {
                        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        return "{}";
                    }
                }
                if (user.getUserType() == null) {
                    mailService.sendRecoverPasswordMail(user);
                    logger.log(LogLevel.INFO, "Parola sıfırlama e-postası gönderim işlemi başarılı: " + user.getUsername());
                } else {
                    if (user.getUserType().equals("BIZZY")) {
                        mailService.sendRecoverPasswordMail(user);
                        logger.log(LogLevel.INFO, "Parola sıfırlama e-postası gönderim işlemi başarılı: " + user.getUsername());
                    } else if (user.getUserType().equals("LDAP")) {
                        logger.log(LogLevel.INFO, "LDAP kullanıcısı şifresi sıfırlanamaz!");
                        return "{\"error\":\"canNotResetLdapUser\"}";
                    }
                }
            } catch (Exception ex) {
                logger.log(LogLevel.ERROR, "Parola sıfırlama e-postası gönderim işlemi başarısız.", ex);
                throw new BizzyException("Parola sıfırlama e-postası gönderim işlemi başarısız.", ex);
            }
        }
        return "{}";
    }

    // Ajax tarafından çağrılıyor.
    @RequestMapping(value = "saveADUsers.json", method = RequestMethod.POST)
    @ResponseBody
    public String saveADUsers(HttpServletRequest request, HttpServletResponse response) throws BizzyException {
        try {
            String customerId = ServletRequestUtils.getStringParameter(request, "customerId", null);            
            String[] userDetailsArr = ServletRequestUtils.getStringParameters(request, "userDetails[]");
            String roleId = ServletRequestUtils.getStringParameter(request, "role", null);
            Date now = new Date();
            
            User checkUser = new User();
            checkUser.setRoleId(roleId);
            checkUser.setRole(aaService.getRole(roleId));
            if (BizzyUtil.hasACustomerRole(HttpUtil.getUser())) {
                if(BizzyUtil.isEmpty(customerId)) {
                    customerId = BizzyUtil.getCustomerIdByUser(HttpUtil.getUser());
                }
                if (!BizzyUtil.isUserAuthorizedForCustomer(HttpUtil.getUser(), customerId)) {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    return "{}";
                }
                if (checkUser.getRoleId() != null) {
                    Set<Role> roles = (Set<Role>) aaService.getRolesOnlyCustomer(HttpUtil.getUser().getUserId());                       
                    if (!roles.stream().filter(o -> o.getId().equals(checkUser.getRoleId())).findFirst().isPresent()) {
                        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        return "{}";
                    }
                }
            } else {
                Set<Role> roles;                       
                if (BizzyUtil.isEmpty(customerId)) {
                    roles = aaService.getRoles(HttpUtil.getUser().getUserId());
                } else {
                    roles = (Set<Role>) aaService.getRolesOnlyCustomer(HttpUtil.getUser().getUserId());
                }
                if (!roles.stream().filter(o -> o.getId().equals(checkUser.getRoleId())).findFirst().isPresent()) {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    return "{}";
                }
            }            
            

            if (BizzyUtil.isApiUser(checkUser)) {
                logger.log(LogLevel.ERROR, "Beklenmeyen kullanıcı rol id'si:" + roleId);
                return "{\"error\":\"failOnParseData\"}";
            }

            if (userDetailsArr.length == 0) {
                return "{\"error\":\"noUser\"}";    //Kullanıcı seçilmedi
            }

            User user = HttpUtil.getUser();
            Customer customer = customerService.getCustomer(customerId);
            
            for (String userDetails : userDetailsArr) {
                String[] details = userDetails.split("&");

                User ldapUser = new User();
                ldapUser.setUsername(details[0]);
                ldapUser.setName(details[1]);
                ldapUser.setSurname(details[2]);
                ldapUser.setEmail(details[3]);
                ldapUser.setDistinguishedName(details[4]); //ldaptan geldiği gibi veritabanına yazılır.
                ldapUser.setRoleId(roleId);        //arayüzden seçilen rol
                ldapUser.setCustomer(customer);
                ldapUser.setCreateBy(user.getUsername());
                ldapUser.setCreationDate(now);
                ldapUser.setEnabled(true);
                ldapUser.setUserType("LDAP");

                String saveResult = aaService.saveUser(ldapUser, customerId);

                switch (saveResult) {
                    case "limit.error": {
                        logger.log(LogLevel.INFO, "Kullanıcı limiti yetersiz, LDAP ekleme işlemi : " + ldapUser.getUsername());
                        return "{\"error\":\"limit\"}";
                    }
                    case "registered.error": {
                        logger.log(LogLevel.INFO, "LDAP Kullanıcı adı önceden eklenmiş, LDAP ekleme işlemi : " + ldapUser.getUsername());
                        return "{\"error\":\"registered\"}";
                    }
                    default:
                        logger.log(LogLevel.INFO, "LDAP Kullanıcı ekleme işlemi başarılı : " + ldapUser.getUsername());
                        try {
                            mailService.sendUserWelcomeMail(ldapUser);
                        } catch (Exception ex){
                            logger.log(LogLevel.INFO, "LDAP Kullanıcısına hoşgeldin maili gönderilemedi : " + ldapUser.getUsername());
                        }
                        break;
                }

            }
        } catch (Exception ex) {
            logger.log(LogLevel.ERROR, "Ldap Kullanıcı ekleme işleminde hata oluştu.", ex);
            return "{\"error\":\"failOnParseData\"}";
        }

        return "{}";
    }

    @RequestMapping(value = "/adUserManagement.htm", method = {RequestMethod.GET})
    public ModelAndView adUserManagement(HttpServletRequest request, HttpServletResponse response, ModelAndView mv) throws BizzyException {
        if (HttpUtil.isGet(request)) {
            try {
                User user = HttpUtil.getUser();
                String customerId = BizzyUtil.getCustomerIdByUser(user);
                Server server = null;
                List<Server> servers = new LinkedList<>();
                if(BizzyUtil.hasACustomerRole(user)) {
                    servers = serverService.getServerByType(ServerType.ACTIVE_DIRECTORY, customerId);
                } else {
                    List <Customer> customerList = new LinkedList<>();
                    servers = serverService.getServerByType(ServerType.ACTIVE_DIRECTORY, null);
                    for (Server adServer: servers) {
                        for (String serverCustomerId: adServer.getCustomerIdSet()) {
                            customerList.add(customerService.getCustomer(serverCustomerId));
                        }
                    }
                    mv.addObject("customerList", customerList);
                    servers = serverService.getDefaultServerByType(ServerType.ACTIVE_DIRECTORY);
                }
                if(!servers.isEmpty()) {
                    server = servers.get(0);
                }
                if (server == null) {
                    mv.addObject("noAD", "adUserManagement.noAD");
                    return mv;
                }
            } catch (Exception ex) {
                logger.log(LogLevel.ERROR, "Active directory sunucu bilgileri alırken hata oluştu.", ex);
                mv.addObject("error", "Active directory sunucu bilgileri alırken hata oluştu!");
            }
            return mv;
        }
        return null;
    }

    @RequestMapping(value = "loadADUsers.json", method = RequestMethod.POST)
    @ResponseBody
    public String loadADUsers(HttpServletRequest request, HttpServletResponse response) {
        String customerId = ServletRequestUtils.getStringParameter(request, "customerId", null);
        String contextName = ServletRequestUtils.getStringParameter(request, "contextName", null);
        String usernameSearch = ServletRequestUtils.getStringParameter(request, "usernameSearch", "");
        try {
            List<User> adUserList = getADUserList(false, customerId, contextName, usernameSearch); // AD kullanıcı listesi

            Collections.sort(adUserList, new Comparator<User>() {   //Username'e göre alfabetik sıralama
                @Override
                public int compare(User a1, User a2) {
                    if (a1.getUsername() == null) {     //null olma durumları handle ediliyor.
                        return (a2.getUsername() == null) ? 0 : -1;
                    }
                    if (a2.getUsername() == null) {
                        return 1;
                    }

                    int compare = a2.getUsername().toLowerCase().compareTo(a1.getUsername().toLowerCase());
                    if (compare < 0) {
                        return 1;
                    } else if (compare > 0) {
                        return -1;
                    } else {
                        return 0;
                    }
                }
            });

            DataTablesRequest dataTablesRequest = DataTablesUtil.getRequest(request);
            int totalCount = adUserList.size();

            return DataTablesUtil.getResponse(dataTablesRequest.getDraw(), totalCount, totalCount,
                    adUserList);
        } catch (Exception ex) {
            logger.log(LogLevel.ERROR, "Ldap kullanıcı listesi alınamadı.", ex);
            return DataTablesUtil.getResponse(0, 0, 0, new ArrayList());
        }

    }

    /**
     * Kayıtlı Active Directory sunucusundan kullanıcı bilgilerini User nesne
     * listesi olarak döner, organizasyon bilgisi veritabanına kayıt edildiyse
     * kullanıcı grupları ile birlikte listeyi döndürür, adem 27.06.2016.
     *
     * @param organizationsSaved
     * @param contextName
     * @param usernameSearch
     * @return
     * @throws tr.biznet.bizzy.domain.BizzyException
     * @throws javax.naming.NamingException
     */
    public List<User> getADUserList(boolean organizationsSaved, String customerId, String contextName, String usernameSearch)
            throws BizzyException, NamingException, BizzySecurityException {
        if(BizzyUtil.isEmpty(customerId)) {
            customerId = BizzyUtil.getCustomerIdByUser(HttpUtil.getUser());
        }
        List<User> userList = new LinkedList();

        Server server = null;
        if(BizzyUtil.isEmpty(customerId)) {
            server = serverService.getDefaultServerByType(ServerType.ACTIVE_DIRECTORY).get(0);
        } else {
            server = serverService.getServerByType(ServerType.ACTIVE_DIRECTORY, customerId).get(0);
        }

        LdapContext ctx = aaService.getLdapContext(server);

        String searchContextName = contextName;

        String searchFilter = server.getUserSearchFilter();
        if (BizzyUtil.isEmpty(searchFilter)) {
            searchFilter = "(&(objectCategory=person)(objectClass=*))";
        }
        SearchControls searchControls = new SearchControls();
        searchControls.setSearchScope(SearchControls.SUBTREE_SCOPE);

        NamingEnumeration<SearchResult> results = null;

        results = ctx.search(searchContextName, searchFilter, searchControls);

        // Kullanıcı bilgisi (organizasyon bilgisi ile birlikte)
        while (results.hasMoreElements()) {
            User user = new User();
            SearchResult currentResult = results.next();
            Attributes attrs = currentResult.getAttributes();

            if (attrs.get("mail") != null) {
                String[] email = attrs.get("mail").toString().split("mail: ");
                user.setEmail(email[1]);
            }
            if (attrs.get("givenname") != null) {
                String[] name = attrs.get("givenname").toString().split("givenName: ");
                user.setName(name[1]);
            }
            if (attrs.get("sn") != null) {
                String[] surname = attrs.get("sn").toString().split("sn: ");
                user.setSurname(surname[1]);
            }
            if (attrs.get("samaccountname") != null) {
                String username[]
                        = attrs.get("samaccountname").toString().split("sAMAccountName: ");
                user.setUsername(username[1]);
            }
            // Bu alandan sadece ilk iki Organizational Unit bilgisi alınıyor. DC bilgileri parse
            // edilmiyor.
            // İlki kullanıcının kendi organizasyonu, ikincisi parent node.
            if (attrs.get("distinguishedName") != null) {
                String distinguishedName = attrs.get("distinguishedName").toString();
                String[] distinguishedNames = distinguishedName.split("distinguishedName: ");
                distinguishedName = distinguishedNames[1];

                Matcher m = RegexUtil.getOrganizationalUnits(distinguishedName);
                List<String> oUs = new LinkedList();
                int oUCount = 0;
                String path = ""; // Ekranda gösterilen organizasyon pathi.
                while (m.find()) {
                    String oU = (String) m.group().subSequence(3, m.group().length() - 1);
                    oUs.add(oU);
                    oUCount++;
                    path += oU + " > ";
                }

                if (oUCount > 0) {
                    path = path.substring(0, path.length() - 3);
                }

                user.setDistinguishedName(distinguishedName);
                user.setOrganizationalPath(path);
            }
            if(usernameSearch.equals("")){
            userList.add(user);
            } else {
                if (user.getUsername() != null) {
                    if (user.getUsername().contains(usernameSearch)) {
                        userList.add(user);
                    }
                }
            }
        }
        return userList;

    }
    
    @RequestMapping(value = "/getContextNames.json", method = RequestMethod.POST, produces = HttpUtil.MIME_TYPE_JSON)
    @ResponseBody
    public String getContextNames(HttpServletRequest request, HttpServletResponse response) {
        try {
            String customerId = ServletRequestUtils.getStringParameter(request, "customerId", null);
            if(BizzyUtil.isEmpty(customerId)) {
                customerId = BizzyUtil.getCustomerIdByUser(HttpUtil.getUser());
            }
            
            JSONObject resp = new JSONObject();
            JSONArray contextNames = new JSONArray();

            Server server = null;
            if(BizzyUtil.isEmpty(customerId)) {
                server = serverService.getDefaultServerByType(ServerType.ACTIVE_DIRECTORY).get(0);
            } else {
                server = serverService.getServerByType(ServerType.ACTIVE_DIRECTORY, customerId).get(0);
            }

            if(!BizzyUtil.isEmpty(server.getFromAddress())) {
                String[] searchContextNameList = server.getFromAddress().split("#");
                if(searchContextNameList.length > 1) {
                    for (String cName : searchContextNameList) {
                        JSONObject object = new JSONObject();
                        object.put("contextName", cName);
                        contextNames.put(object);
                    }
                }
            }

            resp.put("contextNames", contextNames);      
            
            return resp.toString();            
        } catch (Exception ex) {
            logger.log(LogLevel.ERROR, "Ldap Context İsimleri çekilemedi.", ex);
        }
        return null;
    }

    @RequestMapping(value = "/getOrganizationalUnits.json", method = RequestMethod.POST, produces = HttpUtil.MIME_TYPE_JSON)
    @ResponseBody
    public String getOrganizationalUnits(HttpServletRequest request, HttpServletResponse response) {
        try {
            String customerId = ServletRequestUtils.getStringParameter(request, "customerId", null);
            String contextName = ServletRequestUtils.getStringParameter(request, "contextName", null);
            Set<Role> roleList = new HashSet<>();
            if(BizzyUtil.isEmpty(customerId)) {
                customerId = BizzyUtil.getCustomerIdByUser(HttpUtil.getUser());
                roleList = aaService.getRoles(HttpUtil.getUser().getUserId());
            } else {
                roleList = aaService.getCustomerRoles();
            }
            
            JSONObject resp = new JSONObject();
            JSONArray results = new JSONArray();
            JSONArray roles = new JSONArray();
            List<String> organizationalUnits = new LinkedList();

            Server server = null;
            if(BizzyUtil.isEmpty(customerId)) {
                server = serverService.getDefaultServerByType(ServerType.ACTIVE_DIRECTORY).get(0);
            } else {
                server = serverService.getServerByType(ServerType.ACTIVE_DIRECTORY, customerId).get(0);
            }

            LdapContext ctx = aaService.getLdapContext(server);

            String searchContextName;
            if(BizzyUtil.isEmpty(contextName)) {
                searchContextName = server.getFromAddress().split("#")[0]; // dc=sobe,dc=local
            } else {
                searchContextName = contextName;
            }
            // organizational unit = Users OR organizational unit = SystemUsers
            // String searchFilter = "(|(ou=Users)(ou=SystemUsers))";
            String searchFilter = server.getFolderId(); //  (&(objectCategory=container)(objectClass=*))
            if (BizzyUtil.isEmpty(searchFilter)) {
                searchFilter = "(&(objectCategory=organizationalunit)(objectClass=*))";
            }

            SearchControls searchControls = new SearchControls();
            searchControls.setSearchScope(SearchControls.SUBTREE_SCOPE);

            NamingEnumeration<SearchResult> oUs = null;

            oUs = ctx.search(searchContextName, searchFilter, searchControls);
            while (oUs.hasMoreElements()) {
                SearchResult currentResult = oUs.next();
                Attributes attrs = currentResult.getAttributes();
                if (attrs.get("distinguishedName") != null) {
                    String distinguishedName = attrs.get("distinguishedName").toString();
                    String[] distinguishedNames = distinguishedName.split("distinguishedName: ");
                    distinguishedName = distinguishedNames[1];
                    organizationalUnits.add(distinguishedName);
                }
            }
            // sorgular

            for (String path : organizationalUnits) {
                JSONObject oU = new JSONObject();
                oU.put("path", path);
                results.put(oU);
            }
            for (Role role : roleList) {
                JSONObject object = new JSONObject();
                object.put("id", role.getId());
                object.put("roleName", role.getRoleName());
                roles.put(object);
            }

            resp.put("results", results);
            resp.put("roles", roles);

            return resp.toString();
        } catch (Exception ex) {
            logger.log(LogLevel.ERROR, "Ldap organizasyonlar çekilemedi.", ex);
        }
        return null;
    }
    
    private String checkUserRole(User user, Locale locale) {

        String roleId = user.getRoleId();
        if (roleId == null || roleId.equals("")) {
            Map error = new HashMap();
            error.put("flied", "roleError");
            error.put("error", MessageUtil.getLocaleMessage(locale, "configuration.enterValidValue"));
            return gson.toJson(error);
        } else if (!roleId.equals("1")
                && !roleId.equals("2")
                && !roleId.equals("3")
                && !roleId.equals("4")
                && !roleId.equals("5")
                && !roleId.equals("6")
                && !roleId.equals("7")
                && !roleId.equals("8")
                && !roleId.equals("9")
                && !roleId.equals("10")
                && !roleId.equals("11")
                && !roleId.equals("12")
                && !roleId.equals("13")) {
            Map error = new HashMap();
            error.put("flied", "roleError");
            error.put("error", MessageUtil.getLocaleMessage(locale, "configuration.enterValidValue"));
            return gson.toJson(error);
        } else {
            return "correct";
        }

    }
    
}
