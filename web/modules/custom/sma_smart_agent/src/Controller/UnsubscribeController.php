<?php

namespace Drupal\sma_smart_agent\Controller;

use Drupal\Core\Access\AccessResult;
use Drupal\Core\Routing\UrlGeneratorTrait;
use Drupal\Core\Session\AccountInterface;
use Drupal\Core\StringTranslation\StringTranslationTrait;
use Drupal\node\NodeInterface;
use Symfony\Component\Routing\Route;

class UnsubscribeController {

  use StringTranslationTrait;
  use UrlGeneratorTrait;

  public function execute(NodeInterface $node, $token) {
    $node->setPublished(FALSE);
    $node->save();
    drupal_set_message($this->t(sprintf('Unsubscribed from %s smart agent', $node->getTitle())));

    // Redirect to the homepage.
    return $this->redirect('<front>');
  }


  /**
   * Checks routing access for the smart agent unsubscribe.
   *
   * @param \Symfony\Component\Routing\Route $route
   *   The route to check against.
   * @param \Drupal\Core\Session\AccountInterface $account
   *   The currently logged in account.
   * @param \Drupal\node\NodeInterface $node
   *   (optional) A node object. Used for checking access to a node's default
   *   revision when $node_revision is unspecified. Ignored when $node_revision
   *   is specified. If neither $node_revision nor $node are specified, then
   *   access is denied.
   * @param string $token
   *   The unique token of the smart agent.
   *
   * @return \Drupal\Core\Access\AccessResultInterface
   *   The access result.
   */
  public function access(Route $route, AccountInterface $account, NodeInterface $node, $token) {
    return AccessResult::allowedIf($node->get('field_unique_token')->value == $token);
  }
}